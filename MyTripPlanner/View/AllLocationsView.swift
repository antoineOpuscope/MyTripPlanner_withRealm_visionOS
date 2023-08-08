//
//  AllLocationsView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 08/08/2023.
//

import SwiftUI

struct AllLocationsView: View {
    
    var locations: [Location] = [Location]()
    
    @State private var searchText = ""
    
    // Holds one token that we want the user to filter by. This *must* conform to Identifiable.
    struct Token: Identifiable {
        var id = UUID()
        var name: String
    }
    
    let allTokens = [Token(name: "City"), Token(name: "Name"), Token(name: "Country")]
    @State private var currentTokens = [Token]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0...30, id: \.self) {_ in
                    NavigationLink {
                        LocationView()
                    } label: {
                        HStack {
                            Text("\(Image(systemName: "mappin")) name - City")
                        }
                        
                    }
                }
            }.navigationTitle("Pins")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText, tokens: $currentTokens, suggestedTokens: .constant(suggestedTokens), prompt: Text("Type to filter, or use # for tags")) { token in
                                Text(token.name)
                            }
        }
    }
    
    var suggestedTokens: [Token] {
            if searchText.starts(with: "#") {
                return allTokens
            } else {
                return []
            }
        }
    
    // TODO: Use tag for search
    /*
    var searchResults: [String] {
            if searchText.isEmpty {
                return names
            } else {
                return names.filter { $0.contains(searchText) }
            }
        }
     */
}

struct AllLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        AllLocationsView()
    }
}
