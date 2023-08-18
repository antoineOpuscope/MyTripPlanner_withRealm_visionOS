//
//  PinView.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 07/08/2023.
//

import SwiftUI
import CoreLocation

struct PinView: View {
    let pin: Pin
    
    let deleteLocation: () -> Void
    let openLocationView: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30)
                .foregroundColor(pin.color)
                .overlay {
                    Circle()
                        .stroke(.black, lineWidth: 1)
                }
                .shadow(radius: 5)
            Image(systemName: pin.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
            
        }
        .contextMenu(ContextMenu(menuItems: {
            Button(role: .destructive) {
                deleteLocation()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                openLocationView()
            } label: {
                Label("Open", systemImage: "arrow.forward")
            }
        }))
    }
}

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        PinView(pin: Pin(location: TestData.location1), deleteLocation: {}, openLocationView: {})
    }
}
