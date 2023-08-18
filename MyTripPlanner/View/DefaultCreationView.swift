//
//  DefaultCreationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 16/08/2023.
//

import SwiftUI

struct DefaultCreationView: View {
    @Binding private var name: String
    @Binding private var description: String
        
    let saveAction: () -> Void
    let cancelAction: () -> Void
    
    init(name: Binding<String>, description: Binding<String>, saveAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        _name = name
        _description = description
        self.saveAction =  saveAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Project creation")
                    .font(.title)
                HStack {
                    Text("Name : ")
                    TextField("Enter name...", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("Description : ")
                    TextField("Enter description...", text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
            }.padding()
                .navigationBarSaveCancel(saveAction: saveAction, cancelAction: self.cancelAction, name: $name, description: $description)
        }
    }
}

extension View {
    func navigationBarSaveCancel(saveAction: @escaping () -> Void, cancelAction: @escaping () -> Void, name: Binding<String>, description: Binding<String>) -> some View {
        modifier(NavigationBarSaveCancel(saveAction: saveAction, cancelAction: cancelAction, name: name, description: description))
    }
}

struct NavigationBarSaveCancel: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    
    let saveAction: () -> Void
    let cancelAction: () -> Void

    @Binding private var name: String
    @Binding private var description: String
    
    private var isValideForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(saveAction: @escaping () -> Void, cancelAction: @escaping () -> Void, name: Binding<String>, description: Binding<String>) {
        self.saveAction = saveAction
        self.cancelAction = cancelAction
        _name = name
        _description = description
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveAction()
                        self.dismiss()
                    } label: {
                        Text("Save")
                    }.disabled(isValideForm == false)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        cancelAction()
                        self.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                }
            }
    }
}

