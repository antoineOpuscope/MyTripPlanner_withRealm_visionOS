//
//  ContentView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var stateController: StateController
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(stateController.projects, id: \.id) {project in
                    NavigationLink {
                        ProjectView(project: project)
                    } label: {
                        HStack {
                            Text("Project \(project.name)")
                        }
                        
                    }
                }
            }.navigationTitle("Projects")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
