//
//  ProjectView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import MapKit
import RealmSwift

struct ProjectView: View {
    
    @ObservedRealmObject var project: Project
    
    @EnvironmentObject private var stateController: StateController
    @EnvironmentObject private var locationManager: LocationManager
    
    @Environment(\.dismiss) private var dismiss
        
    @State var isEditing: Bool = false
    
    @State var deleteAlertIsPresented = false
    
    private let backgroundColor = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    @State var centerPosition: MapCameraPosition
    
    let frameSize: CGSize = .init(width: 350, height: 300)
    
    init(project: Project) {
        _project = ObservedRealmObject(wrappedValue: project)
        let region: MKCoordinateRegion? = MKCoordinateRegion.init(coordinates: project.locations.map {$0.coordinate}, frameSize: frameSize)
        _centerPosition = State(initialValue:
                .region(region ?? MKCoordinateRegion.init(center: .init(latitude: 0, longitude: 0), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                NavigationLink {
                    ProjectMapView(project: self.project, centerPosition: $centerPosition)
                } label: {
                    MapView(project: project, isContextMenuAllowed: false, cameraPosition: $centerPosition)
                        .allowsHitTesting(false)
                        .frame(height: frameSize.height)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(radius: 10)
                }.padding(.horizontal)
                
                Form {
                    Section {
                        TextField("Name", text: $project.name)
                            .disabled(isEditing == false)
                    } header: {
                        Text("Name")
                    }
                    Section {
                        TextField("Description", text: $project.projectDescription, axis: .vertical)
                            .disabled(isEditing == false)
                    } header: {
                        Text("Description")
                    }
                    
                    Section {
                        Text("\(project.locations.count)")
                    } header: {
                        Text("Location count")
                    }
                }
            }.navigationTitle("\(isEditing ? "Edit" : "") \(project.name)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(isEditing)
                .toolbar {
                    if isEditing {
                        
                        ToolbarItem(placement: .cancellationAction) {
                            Button(role: .destructive) {
                                deleteAlertIsPresented = true
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red)
                            }
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(isEditing ? "Save" : "Edit") {
                            isEditing.toggle()
                            if (isEditing == false) {
                                stateController.updateProject(project: project)
                            }
                        }
                    }
                }
                .onAppear() {
                    // AOM - not possible to set in init because locationManager is not available
                    
                    let region = MKCoordinateRegion.init(coordinates: project.locations.map {$0.coordinate}, frameSize: frameSize)
                    let zeroCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                    if  project.locations.isEmpty {
                        self.centerPosition = .camera(
                                        MapCamera(
                                            centerCoordinate: locationManager.userLocation ?? zeroCoordinate,
                                            distance: 10000,
                                            heading: 92,
                                            pitch: 0
                                        )
                                    )
                    } else if let region = region {
                        self.centerPosition = .region(region)
                    }
                }
                .background(backgroundColor)
                .alert(isPresented: $deleteAlertIsPresented) {
                    
                    Alert(title: Text("Delete"), message: Text("Are you sur you want to delete the project ?"), primaryButton: .cancel(),
                        secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                self.dismiss()
                                stateController.$projects.remove(project)
                                stateController.objectWillChange.send()
                                //stateController.removeProject(project: self.project)
                            }
                        )
                    )
                }
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var centerPosition: MapCameraPosition = .automatic
        
        @StateObject var locationManager = LocationManager()
        @StateObject var stateController = StateController()
        

        var body: some View {
            ProjectView(project: TestData.project)
                .environmentObject(locationManager)
                .environmentObject(stateController)
        }
    }

    static var previews: some View {
        Preview()
    }
}

