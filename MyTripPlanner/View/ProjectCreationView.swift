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
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var stateController: StateController
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Project creation")
                    .font(.title)
                HStack {
                    Text("Name : ")
                    TextField("Enter project name...", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("Description : ")
                    TextField("Enter description...", text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
            }.padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            stateController.addProject(project: Project(name: self.name, description: self.description, locations: []))
                            self.dismiss()
                        } label: {
                            Text("Save")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            self.dismiss()
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(.red)
                        }
                    }
                }
        }
    }
}

#Preview {
    ProjectCreationView()
}
