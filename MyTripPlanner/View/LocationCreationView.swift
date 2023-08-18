//
//  LocationCreationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 16/08/2023.
//

import SwiftUI
import CoreLocation

struct LocationCreationView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    
    @EnvironmentObject private var stateController: StateController
    
    let newTappedCoordinate: CLLocationCoordinate2D
    let project: Project
    
    var body: some View {
        
        let _ = print("newTappedCoordinate \(newTappedCoordinate)")
        
        let location = Location(name: "", description: "", isFavorite: false, color: .green, price: 0, coordinate: self.newTappedCoordinate, icon: "mappin")
        
        DefaultCreationView(name: $name, description: $description,
                            saveAction: {stateController.addLocation(project: project, location: location)},
                            cancelAction: {}
        )
    }
}

#Preview {
    LocationCreationView(newTappedCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), project: TestData.project)
        .environmentObject(StateController())
}
