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
    var project: Project
    var location: Location
    
    @State var name: String
    @State var description: String
    @State var isFavorite: Bool
    @State var color: Color = .green
    @State var price: Float
    @State var coordinate: CLLocationCoordinate2D?
    @State var icon: String = "mappin"
    
    @State var isEditing: Bool = true
    @State var isEmojiPickerPresented: Bool = false
    @State var isSymbolPickerPresented: Bool = false
    
    let latitude = 7.065306
    let longitude = 125.607833
    
    init(project: Project, location: Location) {
        self.project = project
        self.location = location
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
        _isFavorite = State(initialValue: location.isFavorite)
        _color = State(initialValue: location.color)
        _price = State(initialValue: location.price)
        _coordinate = State(initialValue: location.coordinate)
        _icon = State(initialValue: location.icon)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    MapView(project: project, location: location, isContextMenuAllowed: false)
                } label: {
                    MapView(project: project, location: location, isContextMenuAllowed: false)
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
                                ColorPicker("Color", selection: $color)
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
                        TextField("Description", text: $description, axis: .vertical)
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
                SymbolPicker(symbol: $icon)
            }
            .navigationTitle("\(isEditing ? "Edit" : "") Pin")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(isEditing ? "Save" : "Edit") { isEditing.toggle()
                        }
                    }
                    if isEditing {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(role: .destructive) {
                                
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red)
                            }
                        }
                    } else {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                isFavorite.toggle()
                            } label: {
                                Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
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
