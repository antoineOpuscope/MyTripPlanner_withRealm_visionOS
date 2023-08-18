//
//  ProjectCreationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 16/08/2023.
//

import SwiftUI

struct ProjectCreationView: View {
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    @EnvironmentObject private var stateController: StateController
        
    var body: some View {
        
        let project = Project(name: self.name, description: self.description, locations: [])
        
        DefaultCreationView(name: $name, description: $description,
                            saveAction: {stateController.addProject(project: project)},
                            cancelAction: {}
        )
    }
}

#Preview {
    ProjectCreationView()
        .environmentObject(StateController())
}
