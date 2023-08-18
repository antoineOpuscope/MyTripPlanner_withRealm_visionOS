//
//  ProjectMapView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 16/08/2023.
//

import SwiftUI
import CoreLocation

struct ProjectMapView: View {
    
    @ObservedObject var project: Project
    @EnvironmentObject private var stateController: StateController
    
    @State private var isAddingLocation: Bool = false
        
    var body: some View {
        NavigationStack {
            MapView(project: project, isContextMenuAllowed: true, isAddingLocation: $isAddingLocation)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if isAddingLocation == false {
                            Button {
                                isAddingLocation.toggle()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }.navigationTitle("\(project.name)")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProjectMapView(project: TestData.project)
}
