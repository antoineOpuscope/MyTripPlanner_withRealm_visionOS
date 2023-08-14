//
//  TestData.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 14/08/2023.
//

import Foundation

struct TestData {
    static let project: Project = Project(name: "Road-trip France 1", locations: [TestData.location])
    static let location: Location = Location(name: "Place 1", description: "", isFavorite: false, color: .blue, price: 0, icon: "mappin")
}
