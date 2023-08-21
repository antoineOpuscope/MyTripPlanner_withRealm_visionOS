//
//  ProjectView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI

struct ProjectView: View {
    
    @ObservedObject var project: Project
    
    @EnvironmentObject private var stateController: StateController
    
    @Environment(\.dismiss) private var dismiss
        
    @State var isEditing: Bool = false
    
    @State var deleteAlertIsPresented = false
    
    private let backgroundColor = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                NavigationLink {
                    ProjectMapView(project: self.project)
                } label: {
                    MapView(project: project, isContextMenuAllowed: false)
                        .allowsHitTesting(false)
                        .frame(height: 200)
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
                        TextField("Description", text: $project.description)
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
                        
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .destructive) {
                                deleteAlertIsPresented = true
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red)
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(isEditing ? "Save" : "Edit") {
                            isEditing.toggle()
                            if (isEditing == false) {
                                stateController.updateProject(project: project)
                            }
                        }
                    }
                }
                .background(backgroundColor)
                .alert(isPresented: $deleteAlertIsPresented) {
                    
                    Alert(title: Text("Delete"), message: Text("Are you sur you want to delete the project ?"), primaryButton: .cancel(),
                        secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                stateController.removeProject(project: self.project)
                                self.dismiss()
                            }
                        )
                    )
                }
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: TestData.project)
    }
}
