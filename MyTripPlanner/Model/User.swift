//
//  User.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 08/08/2023.
//

import Foundation

class User: ObservableObject, Codable {
    @Published var projects: [Project] = []
    
    enum CodingKeys: String, CodingKey {
        case projects, name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        projects = try container.decode([Project].self, forKey: .projects)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(projects, forKey: .projects)
        try container.encode(name, forKey: .name)
    }
    
    init() {} // Default initializer
}
