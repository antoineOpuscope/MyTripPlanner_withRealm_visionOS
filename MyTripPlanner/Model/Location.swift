//
//  Location.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 08/08/2023.
//

import SwiftUI
import CoreLocation

class Location: Identifiable, Codable, ObservableObject {
    var id = UUID()
    @Published var name: String
    @Published var description: String
    @Published var isFavorite: Bool
    @Published var color: Color = .green
    @Published var price: Float
    @Published var coordinate: CLLocationCoordinate2D
    @Published var icon: String = "mappin"
    
    enum LocationDecodingError: Error {
        case invalidCoordinateData
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, isFavorite, color, price
        case coordinateLatitude = "latitude"
        case coordinateLongitude = "longitude"
    }
    
    init(id: UUID = UUID(), name: String, description: String, isFavorite: Bool, color: Color, price: Float, coordinate: CLLocationCoordinate2D, icon: String) {
        self.id = id
        self.name = name
        self.description = description
        self.isFavorite = isFavorite
        self.color = color
        self.price = price
        self.coordinate = coordinate
        self.icon = icon
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        price = try container.decode(Float.self, forKey: .price)
        
        guard let latitude = try container.decodeIfPresent(Double.self, forKey: .coordinateLatitude),
                  let longitude = try container.decodeIfPresent(Double.self, forKey: .coordinateLongitude) else {
                throw LocationDecodingError.invalidCoordinateData
            }
        
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Decode RGB color values
        if let colorComponents = try container.decodeIfPresent([Double].self, forKey: .color) {
            if colorComponents.count == 3 {
                color = Color(
                    red: colorComponents[0],
                    green: colorComponents[1],
                    blue: colorComponents[2]
                )
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(price, forKey: .price)
        
        // Encode RGB color values
        let colorComponents = color.rgbComponents
        try container.encode(colorComponents, forKey: .color)
        
        try container.encode(coordinate.latitude, forKey: .coordinateLatitude)
        try container.encode(coordinate.longitude, forKey: .coordinateLongitude)
    }
}

extension Color {
    var rgbComponents: [Double] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        return [Double(red), Double(green), Double(blue)]
    }
}
