//
//  ProjectView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI

struct ProjectView: View {
    
    let project: Project
    @EnvironmentObject private var stateController: StateController
    
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String
    @State var description = ""
    @State var tripDate: DateInterval? = nil
    @State var creationDate: Date
    
    @State var locations: [Location] = []
    
    @State var isEditing: Bool = false
    
    private let backgroundColor = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    //https://stackoverflow.com/a/68217351 with we need to use _ and State
    init(project: Project) {
        self.project = project
        _name = State(initialValue: project.name)
        _description = State(initialValue: project.description)
        _tripDate = State(initialValue: project.tripDate)
        _creationDate = State(initialValue: project.creationDate)
        _locations = State(initialValue: project.locations)
    }
    
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
                        Text(project.description)
                    } header: {
                        Text("Description")
                    }
                }
            }.navigationTitle("\(isEditing ? "Edit" : "") \(project.name)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(isEditing)
                .toolbar {
                    if isEditing {
                        
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .destructive) {
                                stateController.removeProject(project: self.project)
                                self.dismiss()
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red)
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(isEditing ? "Save" : "Edit") {
                            isEditing.toggle()
                        }
                    }
                }
                .background(backgroundColor)
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: TestData.project)
    }
}
