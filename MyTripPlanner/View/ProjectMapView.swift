//
//  ProjectMapView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 16/08/2023.
//

import SwiftUI
import CoreLocation
import MapKit

struct ProjectMapView: View {
    
    @ObservedObject var project: Project
    @EnvironmentObject private var stateController: StateController
    
    @State private var isAddingLocation: Bool = false
    @State private var isSearchingLocation: Bool = false
    
    @Binding var centerPosition: MapCameraPosition
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView(project: project, isContextMenuAllowed: true, cameraPosition: $centerPosition, isAddingLocation: $isAddingLocation)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isSearchingLocation.toggle()
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }.disabled(isAddingLocation || isSearchingLocation)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isAddingLocation.toggle()
                            } label: {
                                Image(systemName: "plus")
                            }.disabled(isAddingLocation || isSearchingLocation)
                        }
                        if isSearchingLocation || isAddingLocation {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    isSearchingLocation = false
                                    isAddingLocation = false
                                } label: {
                                    Text("Cancel")
                                }
                            }
                        }
                    }
                if isAddingLocation {
                    VStack {
                        Label("Tap on map to drop a new location", systemImage: "hand.tap")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Spacer()
                    }.padding(.top)
                }
                if isSearchingLocation {
                    SearchingLocationView(isSearchingLocation: $isSearchingLocation, centerPosition: $centerPosition)
                }
            }.navigationTitle("\(project.name)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(isSearchingLocation || isAddingLocation)
        }
    }
}


struct ProjectMapView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var centerPosition: MapCameraPosition = .automatic

        var body: some View {
            ProjectMapView(project: TestData.project, centerPosition: $centerPosition)
                .environmentObject(LocationManager())
        }
    }

    static var previews: some View {
        Preview()
    }
}
