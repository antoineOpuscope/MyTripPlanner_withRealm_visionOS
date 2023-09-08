//
//  ContentView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    var body: some View {
        AllProjectsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StateController())
            .environmentObject(LocationManager())
    }
}
