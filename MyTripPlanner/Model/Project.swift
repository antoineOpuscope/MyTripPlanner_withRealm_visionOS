//
//  Project.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 08/08/2023.
//

import Foundation

class Project: Identifiable, Codable {
    var id = UUID()
    
    var name = ""
    var description = ""
    var tripDate: DateInterval? = nil
    var creationDate: Date = Date.now
    
    var locations: [Location] = []
    
}
