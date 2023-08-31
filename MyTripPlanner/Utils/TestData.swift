//
//  TestData.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 14/08/2023.
//

import Foundation
import SwiftUI
import CoreLocation

struct TestData {
    // swiftlint:disable:next line_length
    static let project: Project = Project(name: "Road-trip France 1", description: "Omnium vivendi sub enim praediximus pollicitos ob molitioni Epigonus sub praediximus vocabulis et tribunos fabricarum tribunos Epigonus fabricarum igitur igitur gentilitatem vivendi praediximus pollicitos statuuntur vivendi molitioni vocabulis vocabulis vivendi.", locations: [TestData.location1, TestData.location2, TestData.location3])
    // swiftlint:disable:next line_length
    static let location1: Location = Location(name: "Place 1", description: "Omni Nam tempore perpetuae belli decernendis rationem nobis belli nos habere hoc hoc intellego tempore Nam alia nobis conscripti intellego omni perpetuae periculo perpetuae habere etiam non esse hoc decernendis.", isFavorite: false, color: .blue, price: 0, coordinate: CLLocationCoordinate2D(latitude: 48.85828676671761, longitude: 2.295548475176827), icon: "mappin")
    // swiftlint:disable:next line_length
    static let location2: Location = Location(name: "Place 2", description: "", isFavorite: false, color: .yellow, price: 0, coordinate: CLLocationCoordinate2D(latitude: 48.8437637557084, longitude: 2.3047341429913013), icon: "mappin")
    // swiftlint:disable:next line_length
    static let location3: Location = Location(name: "Place 3", description: "", isFavorite: false, color: .pink, price: 0, coordinate: CLLocationCoordinate2D(latitude: 48.84965726942819, longitude: 2.323792739725356), icon: "mappin")
}
