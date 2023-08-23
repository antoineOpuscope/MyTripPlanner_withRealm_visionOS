//
//  SearchingLocationView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 23/08/2023.
//

import SwiftUI

struct SearchingLocationView: View {
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
            }.padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray)
                )
            Spacer()
        }.padding()
            .background(.white)
    }
}

#Preview {
    SearchingLocationView()
}
