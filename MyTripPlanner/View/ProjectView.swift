//
//  ProjectView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI

struct ProjectView: View {
    
    let project: Project
    
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
                    MapView(project: project)
                } label: {
                    MapView(project: project)
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
                    
                    if (isEditing == false) {
                        Section {
                            NavigationLink {
                                ExportView()
                            } label: {
                                Text("Export")
                                    .font(.subheadline)
                                    .bold()
                            }
                            NavigationLink {
                                AllLocationsView(project: project)
                            } label: {
                                Text("Locations")
                                    .font(.subheadline)
                                    .bold()
                            }
                        } header: {
                            Text("Actions")
                        }
                    }
                }
            }.navigationTitle("\(isEditing ? "Edit" : "")\(project.name)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button(isEditing ? "Save" : "Edit") {}
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
