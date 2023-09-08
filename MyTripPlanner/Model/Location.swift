//
//  Location.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 08/08/2023.
//

import SwiftUI
import CoreLocation
import RealmSwift

class Location: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var name: String
    @Persisted var locationDescription: String
    @Persisted var isFavorite: Bool
    @Persisted var colorComponents: RealmSwift.List<Double>
    @Persisted var price: Float
    @Persisted var longitude: Double
    @Persisted var latitude: Double
    @Persisted var icon: String = "mappin"
    
    @Persisted(originProperty: "locations") var project: LinkingObjects<Project>
    
    override class public func propertiesMapping() -> [String: String] {
        ["locationDescription": "description"]
    }
    
    convenience init(name: String, locationDescription: String, isFavorite: Bool, color: Color, price: Float, coordinate: CLLocationCoordinate2D, icon: String) {
        self.init()

        self.name = name
        self.locationDescription = locationDescription
        self.isFavorite = isFavorite
        self.colorComponents = color.colorToRealmList
        self.price = price
        self.longitude = coordinate.longitude
        self.latitude = coordinate.latitude
        self.icon = icon
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
    }
    
    var color: Color {
        get {
            // Convert the stored hexadecimal string back to a Color
            if colorComponents.count != 3 {
                return .red
            }
            return Color(
                red: colorComponents[0],
                green: colorComponents[1],
                blue: colorComponents[2]
            )
        }
        set {
            // TODO: AOM - Find a better way to initialize
            colorComponents = newValue.colorToRealmList
        }
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
    
    var colorToRealmList: RealmSwift.List<Double> {
        let components = RealmSwift.List<Double>()
        components.append(self.rgbComponents[0])
        components.append(self.rgbComponents[1])
        components.append(self.rgbComponents[2])
        // Convert the Color to a hexadecimal string for storage
        return components
    }
}
