//
//  LocationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import SymbolPicker
import EmojiPicker
import Combine
import CoreLocation
import MapKit

struct LocationView: View {
    @ObservedObject var project: Project
    @ObservedObject var location: Location
    
    @State var isEditing: Bool = false
    @State var isEmojiPickerPresented: Bool = false
    @State var isSymbolPickerPresented: Bool = false
    @State var deleteAlertIsPresented = false
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var stateController: StateController

    @State var placemark: CLPlacemark?
    
    @State var centerPosition: MapCameraPosition
    
    let geoCoder = CLGeocoder()
    
    let latitude = 7.065306
    let longitude = 125.607833
    
    private var cancellable = Set<AnyCancellable>()

    init(project: Project,  location: Location) {
        self.project = project
        self.location = location
        _centerPosition = State(initialValue:
            .camera(
                    MapCamera(
                        centerCoordinate: location.coordinate,
                        distance: 10000,
                        heading: 92,
                        pitch: 0
                    )
                )
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                NavigationLink {
                    MapView(project: project, isContextMenuAllowed: false, cameraPosition: $centerPosition, location: location)
                } label: {
                    MapView(project: project, isContextMenuAllowed: false, cameraPosition: $centerPosition, location: location)
                        .allowsHitTesting(false)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(radius: 10)
                }.padding(.horizontal)
                
                Form {
                    Section {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(location.color)
                                
                                Image(systemName: location.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            Spacer()
                            if (isEditing) {
                                ColorPicker("Color", selection: $location.color)
                                    .labelsHidden()
                                    
                                Button("Choose icon")  {
                                    isSymbolPickerPresented = true
                                }
                                    .padding(5)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blue, lineWidth: 1)
                                    }
                            }
                        }
                        
                    } header: {
                        Text("Visual")
                    }
                    
                    Section {
                        TextField("Name", text: $location.name)
                            .disabled(isEditing == false)
                        if let placemark = self.placemark {
                            Text("\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            ProgressView()
                        }
                    } header: {
                        Text("Name")
                    }
                    
                    Section {
                        TextField("Description", text: $location.description, axis: .vertical)
                            .disabled(isEditing == false)
                    } header: {
                        Text("Description")
                    }
                    
                    Section {
                        if let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)") {
                            Link("Open with GPS", destination: url)
                        }
                        
                    } header: {
                        Text("Actions")
                    }
                }
                
            }.sheet(isPresented: $isSymbolPickerPresented) {
                SymbolPicker(symbol: $location.icon)
            }
            .navigationTitle("\(isEditing ? "Edit" : "") Pin")
            .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(isEditing)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(isEditing ? "Save" : "Edit") {
                            isEditing.toggle()
                            if (isEditing == false) {
                                stateController.updateLocation(project: project, location: location)
                            }
                        }
                    }
                    if isEditing {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(role: .destructive) {
                                self.deleteAlertIsPresented = true
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red)
                            }
                        }
                    } else {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                location.isFavorite.toggle()
                            } label: {
                                Image(systemName: location.isFavorite ? "bookmark.fill" : "bookmark")
                            }
                        }
                    }
                }
                .alert(isPresented: $deleteAlertIsPresented) {
                    
                    Alert(title: Text("Delete"),
                          message: Text("Are you sur you want to delete the location ?"),
                          primaryButton: .cancel(),
                          secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                stateController.removeLocation(project: project, location: location)
                                self.dismiss()
                            }
                        )
                    )
                }
                .onAppear {
                    location.$coordinate.sink { coordinate in
                        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        self.geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                            self.placemark = placemarks?.first
                        })
                    }.store(in: &cancellable)
                }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(project: TestData.project, location: TestData.location1)
            .environmentObject(LocationManager())
    }
}
