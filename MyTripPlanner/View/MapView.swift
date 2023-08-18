//
//  MapView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
        
    @ObservedObject var project: Project
    // AOM - @ObservedObject not needed because we wont edit it
    var location: Location?
    
    var isContextMenuAllowed: Bool
    
    @EnvironmentObject private var stateController: StateController
    
    @State private var isCreateLocationSheetPresented: Bool = false
    
    @Binding var isAddingLocation: Bool
    @State var tappedCoordinates: Coordinate? = nil
    
    struct Coordinate: Identifiable {
        let id = UUID()
        var tappedCoordinates: CLLocationCoordinate2D

        init(tappedCoordinates: CLLocationCoordinate2D) {
            self.tappedCoordinates = tappedCoordinates
        }
    }
        
    @State private var cameraProsition: MapCameraPosition = .camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(latitude: 48.858046588769085, longitude:  2.2949914738436776),
                distance: 10000,
                heading: 92,
                pitch: 0
            )
        )
    
    init(project: Project, isContextMenuAllowed: Bool, isAddingLocation: Binding<Bool> = .constant(false), location: Location? = nil) {
        _project = ObservedObject(wrappedValue: project)
        self.location = location
        self.isContextMenuAllowed = isContextMenuAllowed
        //https://sarunw.com/posts/binding-initialization/
        _isAddingLocation = isAddingLocation
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapReader { reader in
                    ZStack {
                        Map(
                            position: $cameraProsition,
                            interactionModes: [.all]
                        )
                        {
                            if let location {
                                ForEach([Pin(location: location)], id:\.id) { pin in
                                    Annotation("", coordinate: pin.coordinate) {
                                        PinView(pin: pin)
                                    }
                                }
                            } else {
                                ForEach(project.pins, id:\.id) { pin in
                                    Annotation("", coordinate: pin.coordinate) {
                                        NavigationLink {
                                            LocationView(project: self.project, location: pin.location)
                                        } label: {
                                            PinView(pin: pin)
                                                .contextMenu(ContextMenu(menuItems: {
                                                    Button(role: .destructive) {
                                                        stateController.removeLocation(project: self.project, location: pin.location)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }))
                                        }
                                    }
                                }
                            }
                        }
                        .onTapGesture(perform: { screenCoord in
                            if self.isAddingLocation {
                                if let tappedCoordinate = reader.convert(screenCoord, from: .local) {
                                    tappedCoordinates = Coordinate(tappedCoordinates: tappedCoordinate)
                                    self.isCreateLocationSheetPresented = true
                                }
                            }
                        })
                        .mapControls{
                            MapCompass()
                        }
                        .mapStyle(.standard(elevation: .flat))
                        .sheet(item: $tappedCoordinates) { _ in
                            if let tappedCoordinates {
                                LocationCreationView(newTappedCoordinate: tappedCoordinates.tappedCoordinates, project: project)
                                    .environmentObject(stateController)
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(project: TestData.project, isContextMenuAllowed: true)
    }
}
