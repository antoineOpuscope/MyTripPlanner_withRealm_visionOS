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
    var body: some View {
        
        @State var isEditing: Bool = true
        @State var isEmojiPickerPresented: Bool = false
        @State var isSymbolPickerPresented: Bool = false
        
        @State var isReserved: Bool = false
        @State var isFavorite: Bool = false
        @State var price: Float = 0
        @State var icon = "mappin"
        
        NavigationStack {
            VStack {
                MapView()
                    .allowsHitTesting(false)
                    .frame(height: 300)
                    .padding(.top)
                
                Form {
                    Section {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.cyan)
                                
                                Image(systemName: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            Spacer()
                            if (isEditing) {
                                Button("Choose color") {
                                    
                                }
                                    .padding(5)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blue, lineWidth: 1)
                                    }
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
                        Text("Dasdad")
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
                        Button("Open with GPS") {}
                    } header: {
                        Text("Actions")
                    }
                }
                
            }.navigationTitle("Pin")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(isEditing ? "Save" : "Edit") { isEditing.toggle()
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                                isFavorite.toggle()
                        } label: {
                            Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                        }
                    }
                }
        }.sheet(isPresented: $isEmojiPickerPresented) {
            SymbolPicker(symbol: $icon)
        }.sheet(isPresented: $isSymbolPickerPresented) {
            SymbolPicker(symbol: $icon)
        }
        
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
