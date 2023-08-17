//
//  ContentView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var stateController: StateController
    
    @State var isCreateProjectViewPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(stateController.projects, id: \.id) {project in
                    NavigationLink {
                        ProjectView(project: project)
                    } label: {
                        HStack {
                            Text("\(project.name)")
                        }
                        
                    }
                }
            }.navigationTitle("Projects")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add", systemImage: "plus") {
                            self.isCreateProjectViewPresented = true
                        }
                    }
                }
                .sheet(isPresented: $isCreateProjectViewPresented) {
                    ProjectCreationView()
                        .environmentObject(stateController)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StateController())
    }
}
