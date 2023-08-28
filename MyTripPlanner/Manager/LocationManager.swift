//
//  LocationManager.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 23/08/2023.
//

import Foundation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    @Published private var mapView: MKMapView = .init()
    @Published private var manager: CLLocationManager = .init()
    
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    
    @Published var fetchedPlaces: [CLPlacemark]? = nil
    
    // Only updated once
    @Published var userLocation: CLLocationCoordinate2D? = nil
    
    override init() {
        super.init()
        mapView.delegate = self
        manager.delegate = self
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value.isEmpty == false {
                    self.fetchPlaces(value: value)
                } else {
                    self.fetchedPlaces = nil
                }
        })
    }
    
    func fetchPlaces(value: String) {
        print(value)
        
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            } catch {
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.userLocation = location.coordinate
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            manager.requestWhenInUseAuthorization()
        case .denied:
            self.handleLocationError()
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        @unknown default:
            ()
        }
    }
    
    func handleLocationError() {
        
    }
}
