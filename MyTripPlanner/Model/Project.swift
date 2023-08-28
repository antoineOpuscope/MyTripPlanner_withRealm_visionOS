//
//  Project.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 08/08/2023.
//

import Foundation
import Combine
import CoreLocation

class Project: Identifiable, Codable, ObservableObject {
    var id = UUID()
    
    @Published var name: String
    @Published var description = ""
    @Published var tripDate: DateInterval? = nil
    @Published var creationDate: Date
    
    // TODO keep only the id of location and create a list location in StateController
    @Published var locations: [Location] = []
    @Published var pins: [Pin] = []
    
    private var subscribers: Set<AnyCancellable> = []

    func computeCenter() -> CLLocationCoordinate2D? {
        let coordinates = locations.map({ $0.coordinate})
        guard !coordinates.isEmpty else {
            return nil
        }
        
        var totalLatitude: Double = 0
        var totalLongitude: Double = 0
        
        for coordinate in coordinates {
            totalLatitude += coordinate.latitude
            totalLongitude += coordinate.longitude
        }
        
        let averageLatitude = totalLatitude / Double(coordinates.count)
        let averageLongitude = totalLongitude / Double(coordinates.count)
        
        return CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
    }
    
    init(id: UUID = UUID(), name: String, description: String = "", tripDate: DateInterval? = nil, locations: [Location]) {
        self.id = id
        self.name = name
        self.description = description
        self.tripDate = tripDate
        self.locations = locations
        self.creationDate = Date()
        
        $locations.sink { locations in
            self.pins = locations.map {Pin(location: $0)}
        }.store(in: &subscribers)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case tripDate
        case creationDate
        case locations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        tripDate = try container.decodeIfPresent(DateInterval.self, forKey: .tripDate)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        locations = try container.decode([Location].self, forKey: .locations)
        
        // AOM - Maybe it should be in the view
        $locations.sink { locations in
            self.pins = locations.map {Pin(location: $0)}
        }.store(in: &subscribers)
        
        // For decoding the UUID from a string representation
        if let idString = try? container.decode(String.self, forKey: .id),
           let decodedId = UUID(uuidString: idString) {
            id = decodedId
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(tripDate, forKey: .tripDate)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(locations, forKey: .locations)
        
        // For encoding the UUID as a string representation
        try container.encode(id.uuidString, forKey: .id)
    }
}
