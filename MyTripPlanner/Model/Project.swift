//
//  Project.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 08/08/2023.
//

import Foundation

class Project: Identifiable, Codable {
    var id = UUID()
    
    var name: String
    var description = ""
    var tripDate: DateInterval? = nil
    var creationDate: Date
    
    var locations: [Location] = []
    
    init(id: UUID = UUID(), name: String, description: String = "", tripDate: DateInterval? = nil, locations: [Location]) {
        self.id = id
        self.name = name
        self.description = description
        self.tripDate = tripDate
        self.locations = locations
        self.creationDate = Date.now
    }
}
