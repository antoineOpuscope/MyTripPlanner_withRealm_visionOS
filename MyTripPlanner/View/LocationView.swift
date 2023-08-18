//
//  LocationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import SymbolPicker
import EmojiPicker
import CoreLocation

struct LocationView: View {
    @ObservedObject var project: Project
    @ObservedObject var location: Location
    
    @State var isEditing: Bool = true
    @State var isEmojiPickerPresented: Bool = false
    @State var isSymbolPickerPresented: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var stateController: StateController

    let latitude = 7.065306
    let longitude = 125.607833
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    MapView(project: project, isContextMenuAllowed: false, location: location)
                } label: {
                    MapView(project: project, isContextMenuAllowed: false, location: location)
                        .allowsHitTesting(false)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(radius: 10)
                }.padding(.horizontal)
                
                Form {
                    Section {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(location.color)
                                
                                Image(systemName: location.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            Spacer()
                            if (isEditing) {
                                ColorPicker("Color", selection: $location.color)
                                    .labelsHidden()
                                    
                                Button("Choose icon")  {
                                    isSymbolPickerPresented = true
                                }
                                    .padding(5)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blue, lineWidth: 1)
                                    }
                            }
                        }
                        
                    } header: {
                        Text("Visual")
                    }
                    
                    Section {
                        TextField("Description", text: $location.description, axis: .vertical)
                            .disabled(isEditing == false)
                    } header: {
                        Text("Description")
                    }
                    
                    Section {
                        if let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)") {
                            Link("Open with GPS", destination: url)
                        }
                        
                    } header: {
                        Text("Actions")
                    }
                }
                
            }.sheet(isPresented: $isSymbolPickerPresented) {
                SymbolPicker(symbol: $location.icon)
            }
            .navigationTitle("\(isEditing ? "Edit" : "") Pin")
            .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(isEditing)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(isEditing ? "Save" : "Edit") { isEditing.toggle()
                        }
                    }
                    if isEditing {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .destructive) {
                                stateController.removeLocation(project: project, location: location)
                                self.dismiss()
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red)
                            }
                        }
                    } else {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                location.isFavorite.toggle()
                            } label: {
                                Image(systemName: location.isFavorite ? "bookmark.fill" : "bookmark")
                            }
                        }
                    }
                }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(project: TestData.project, location: TestData.location1)
    }
}
