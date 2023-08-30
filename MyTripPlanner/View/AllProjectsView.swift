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
            }.navigationTitle("\(isMergingProjects ? "Merging " : "")Projects")
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
                        if isMergingProjects == false && stateController.projects.count >= 2 {
                            Button("Add", systemImage: "arrow.triangle.merge") {
                                self.isMergingProjects.toggle()
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        if isMergingProjects && self.multiSelection.count >= 2 {
                            Button {
                                self.isPresentedMergeConfirmationAlert = true
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.green)
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
                                stateController.mergeSelectedProjects(selectedProject: multiSelection)
                                self.isMergingProjects = false
                            }
                        )
                    )
                }
        }
    }
}

#Preview {
    AllProjectsView()
        .environmentObject(StateController())
}
