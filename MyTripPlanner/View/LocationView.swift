//
//  LocationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import SymbolPicker
import EmojiPicker

struct LocationView: View {
    
    @State var isEditing: Bool = true
    @State var isEmojiPickerPresented: Bool = false
    @State var isSymbolPickerPresented: Bool = false
    
    @State var isReserved: Bool = false
    @State var isFavorite: Bool = false
    @State var price: Float = 0
    @State var icon = "mappin"
    @State var color = Color.blue
    
    @State var description = "Appela ete fin crosse moi ecarta lazzis. Glisse pleine bas pas charge boules but touffe raison pic. Des monte iii decor ans crete ils. Murmure allures je encourt beffroi ensuite il geantes. Et durant eperon gloire balaye canons labour je ah. Avons ils peu oncle eux canif drape irise."
    
    let latitude = 7.065306
    let longitude = 125.607833
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    MapView()
                } label: {
                    MapView()
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
                                    .foregroundColor(color)
                                
                                Image(systemName: icon)
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
                        Toggle(isOn: $isReserved) {
                            Text("Booked :")
                        }
                        .toggleStyle(.switch)
                        .disabled(isEditing == false)
                        
                        Text("Price: \(price.formatted()) $")
                        
                        
                    } header: {
                        Text("Booking info")
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
            .navigationTitle("Pin")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(isEditing ? "Save" : "Edit") { isEditing.toggle()
                        }
                    }
                    if isEditing == false {
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
        LocationView()
    }
}
