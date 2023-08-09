//
//  MapView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    let pins: [Pin] = [
        Pin(name: "A", coordinate: CLLocationCoordinate2D(latitude: 48.85828676671761, longitude: 2.295548475176827), icon: "mappin", color: Color.blue),
        Pin(name: "B", coordinate: CLLocationCoordinate2D(latitude: 48.84965726942819, longitude: 2.323792739725356), icon: "mappin", color: Color.yellow),
        Pin(name: "C", coordinate: CLLocationCoordinate2D(latitude: 48.8437637557084, longitude: 2.3047341429913013), icon: "books.vertical", color: Color.pink),
    ]
    
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.858046588769085, longitude:  2.2949914738436776),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: pins) { pin in
            MapAnnotation(coordinate: pin.coordinate) {
                PinView(pin: pin)
            }
        }
            .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
