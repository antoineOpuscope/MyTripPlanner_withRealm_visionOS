//
//  ExtensionCLLocationCoordinate2D.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 25/08/2023.
//

import Foundations
import CoreLocation

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    // 0.00018 to be precis at 20m de distances
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return abs(lhs.latitude - rhs.latitude) <= 0.00018 && abs(lhs.longitude - rhs.longitude) <= 0.00018
    }
}
