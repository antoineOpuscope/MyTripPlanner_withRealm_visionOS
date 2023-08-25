//
//  AllProjectsView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 23/08/2023.
//

import SwiftUI
import CoreLocation

struct AllProjectsView: View {
    
    @EnvironmentObject private var stateController: StateController
    
    @State var isCreateProjectViewPresented: Bool = false
    
    @State private var multiSelection = Set<UUID>()
    @State private var isPresentedMergeConfirmationAlert = false
    
    @State var isMergingProjects = false
    
    var body: some View {
        NavigationStack {
            List(selection: $multiSelection) {
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
                .environment(\.editMode, .constant(self.isMergingProjects ? EditMode.active : EditMode.inactive))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add", systemImage: "plus") {
                            self.isCreateProjectViewPresented = true
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        if isMergingProjects {
                            
                            Button {
                                self.isMergingProjects.toggle()
                            } label: {
                                Image(systemName: "multiply")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        if isMergingProjects == false {
                            Button("Add", systemImage: "arrow.triangle.merge") {
                                self.isMergingProjects.toggle()
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        if isMergingProjects && self.multiSelection.count >= 2 {
                            Button("arrow.triangle.merge", systemImage: "checkmark") {
                                
                                //
                                self.isPresentedMergeConfirmationAlert = true
                            }
                        }
                    }
                }
                .sheet(isPresented: $isCreateProjectViewPresented) {
                    ProjectCreationView()
                        .environmentObject(stateController)
                }
                .alert(isPresented: $isPresentedMergeConfirmationAlert) {
                    
                    Alert(title: Text("Merging"),
                          message: Text("Are you sur you want to merge the selected projects ?"),
                          primaryButton: .destructive(
                            Text("Cancel"),
                            action: {
                                
                            }
                          ),
                          secondaryButton: .default(
                            Text("Confirm"),
                            action: {
                                let project: Project = mergeSelectedProjects()
                                stateController.addProject(project: project)
                                self.isMergingProjects = false
                            }
                        )
                    )
                }
        }
    }
    
    func mergeSelectedProjects() -> Project {
        let selectedProjects: [Project] = stateController.projects.filter {multiSelection.contains($0.id)}
        
        // Create a set to store unique coordinates
        var uniqueCoordinates = Set<CLLocationCoordinate2D>()

        // Use flatMap to extract all Location objects from the projects
        let allUniqueLocations = selectedProjects.flatMap { project in
            project.locations.filter {
                // Insert the coordinate into the set, and only keep the location if it's unique
                uniqueCoordinates.insert($0.coordinate).inserted
            }
        }
        
        let project = Project(name: selectedProjects.map {$0.name}.joined(separator: "-"), locations: allUniqueLocations)
        
        return project
    }
}

#Preview {
    AllProjectsView()
        .environmentObject(StateController())
}
