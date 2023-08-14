//
//  MapView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
        
    var project: Project
    var location: Location?
    
    @State var pins: [Pin]
    
    @State private var cameraProsition: MapCameraPosition = .camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(latitude: 48.858046588769085, longitude:  2.2949914738436776),
                distance: 10000,
                heading: 92,
                pitch: 0
            )
        )
    
    init(project: Project, location: Location? = nil) {
        self.project = project
        self.location = location
        if let location {
            _pins = State(initialValue: [Pin(location: location)])
        } else {
            _pins = State(initialValue: project.locations.map {Pin(location: $0)})
        }
    }
    
    var body: some View {
        ZStack {
            Color.blue
            
            MapReader { reader in
                ZStack {
                    Map(
                        position: $cameraProsition,
                        interactionModes: [.all]
                    )
                    {
                        ForEach(pins, id:\.id) { pin in
                            Annotation("", coordinate: pin.coordinate) {
                                PinView(pin: pin)
                            }
                        }
                    }
                    .onTapGesture(perform: { screenCoord in
                        /*
                        if let tappedCoordinate = reader.convert(screenCoord, from: .local) {
                            pins.append(Pin(location: Location(name: "New location", description: "", isFavorite: false, color: .green, price: 0, coordinate: tappedCoordinate, icon: "mappin")))
                        }
                         */
                    })
                    .mapControls{
                        MapCompass()
                    }
                    .mapStyle(.standard(elevation: .flat))
                    

                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(project: TestData.project, location: nil)
    }
}
