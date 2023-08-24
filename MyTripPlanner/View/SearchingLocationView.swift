//
//  SearchingLocationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 23/08/2023.
//

import SwiftUI
import _MapKit_SwiftUI

struct SearchingLocationView: View {
        
    @EnvironmentObject private var locationManager: LocationManager
    
    @Binding var isSearchingLocation: Bool
    @Binding var centerPosition: MapCameraPosition
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $locationManager.searchText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }.padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray)
                )
            Spacer()
            
            if let places = locationManager.fetchedPlaces, places.isEmpty == false {
                List {
                    ForEach(places, id:\.self) { place in
                        HStack(spacing: 15) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(place.name ?? "")
                                    .font(.title3.bold())
                                Text(place.locality ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }.onTapGesture {
                            isSearchingLocation = false
                            if let coordinate = place.location?.coordinate {
                                centerPosition = .camera(
                                    MapCamera(
                                        centerCoordinate: coordinate,
                                        distance: 10000,
                                        heading: 92,
                                        pitch: 0
                                    )
                                )
                            }
                            print(place.locality)
                        }
                    }
                }
            }
        }.padding()
            .background(.white)
    }
}

struct SearchingLocationView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var locationManager = LocationManager()
        @State private var isSearchingLocation = false
        @State var centerPosition: MapCameraPosition = .automatic

        var body: some View {
            SearchingLocationView(isSearchingLocation: $isSearchingLocation, centerPosition: $centerPosition)
            .environmentObject(locationManager)
        }
    }

    static var previews: some View {
        Preview()
    }
}
