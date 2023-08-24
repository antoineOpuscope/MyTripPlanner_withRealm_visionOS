//
//  SearchingLocationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 23/08/2023.
//

import SwiftUI

struct SearchingLocationView: View {
        
    @EnvironmentObject private var locationManager: LocationManager
    
    @Binding var isSearchingLocation: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $locationManager.searchText)
            }.padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray)
                )
            Spacer()
            
            if let places = locationManager.fetchedPlaces, places.isEmpty == false {
                List {
                    ForEach(places, id:\.self) { place in
                        HStack(spacing: 15) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(place.name ?? "")
                                    .font(.title3.bold())
                                Text(place.locality ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }.onTapGesture {
                            isSearchingLocation = false
                            print(place.locality)
                        }
                    }
                }
            }
        }.padding()
            .background(.white)
    }
}

struct SearchingLocationView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var locationManager = LocationManager()
        @State private var isSearchingLocation = false

        var body: some View {
            SearchingLocationView(isSearchingLocation: $isSearchingLocation)
            .environmentObject(locationManager)
        }
    }

    static var previews: some View {
        Preview()
    }
}
