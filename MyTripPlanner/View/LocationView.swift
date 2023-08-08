//
//  LocationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI

struct LocationView: View {
    var body: some View {
        
        @State var isEditing: Bool = true
        
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
                                
                                Image(systemName: "mappin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            Spacer()
                            Button("Choose color") {}
                                .padding(5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.blue, lineWidth: 1)
                                }
                            Button("Choose icon")  {}
                                .padding(5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.blue, lineWidth: 1)
                                }
                            
                        }
                        
                    } header: {
                        Text("Visual")
                    }
                }
                
            }.navigationTitle("Pin")
                .toolbar {
                    Button(isEditing ? "Save" : "Edit") {}
                }
        }
        
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
