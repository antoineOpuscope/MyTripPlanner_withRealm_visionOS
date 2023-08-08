//
//  ProjectView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI

struct ProjectView: View {
    
    //@EnvironmentObject var project: Project
    
    @State var name = "Project 1"
    @State var description = "Appela ete fin crosse moi ecarta lazzis. Glisse pleine bas pas charge boules but touffe raison pic. Des monte iii decor ans crete ils. Murmure allures je encourt beffroi ensuite il geantes. Et durant eperon gloire balaye canons labour je ah. Avons ils peu oncle eux canif drape irise."
    @State var tripDate: DateInterval? = DateInterval(start: .now, end: .distantFuture)
    @State var creationDate: Date = Date.now
    @State var membres: [String]? = nil
    
    var visitLocations: [VisitLocation] = []
    var hotelLocations: [HotelLocation] = []
    
    @State var isEditing: Bool = false
    
    private let backgroundColor = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                if let tripDate {
                    
                    MapView()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(radius: 10)
                        .padding()
                    
                    Form {
                        Section {
                            Text("\(tripDate.start.formatted(date: .abbreviated, time: .omitted)) \(Image(systemName: "arrow.left.and.right")) \(tripDate.end.formatted(date: .abbreviated, time: .omitted))")
                            
                            
                            
                            
                        } header: {
                            Text("Date")
                        }
                        Section {
                            Text(self.description)
                        } header: {
                            Text("Description")
                        }
                        
                        if (isEditing == false) {
                            Section {
                                NavigationLink {
                                    MapView()
                                } label: {
                                    Text("Display map")
                                        .font(.subheadline)
                                        .bold()
                                }
                                NavigationLink {
                                    ExportView()
                                } label: {
                                    Text("Export")
                                        .font(.subheadline)
                                        .bold()
                                }
                                NavigationLink {
                                    AllLocationsView()
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
                    
                }
            }.navigationTitle(name)
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .toolbar {
                    Button(isEditing ? "Save" : "Edit") {}
                }
                .background(backgroundColor)
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
