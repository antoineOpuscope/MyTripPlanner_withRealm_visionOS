//
//  ContentView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var user: User = User()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0...11, id: \.self) {i in
                    NavigationLink {
                        ProjectView()
                    } label: {
                        HStack {
                            Text("Project \(i)")
                        }
                        
                    }
                }
            }.navigationTitle("Projects")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
