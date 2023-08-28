//
//  MKCoordinateRegionExtension.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 28/08/2023.
//

import Foundation
import MapKit
import SwiftUI


// inspired by https://gist.github.com/dionc/46f7e7ee9db7dbd7bddec56bd5418ca6 and usage of chatGPT
extension MKCoordinateRegion {
    
    // Initializer to account for the view's size
    init?(coordinates: [CLLocationCoordinate2D], frameSize: CGSize) {
        let primeRegion = MKCoordinateRegion.region(for: coordinates, transform: { $0 }, inverseTransform: { $0 })
        
        let transformedRegion = MKCoordinateRegion.region(for: coordinates, transform: MKCoordinateRegion.transform, inverseTransform: MKCoordinateRegion.inverseTransform)
        
        if let a = primeRegion,
            let b = transformedRegion,
            let min = [a, b].min(by: { $0.span.longitudeDelta < $1.span.longitudeDelta }) {
            self = min
        }
        else if let a = primeRegion {
            self = a
        }
        else if let b = transformedRegion {
            self = b
        }
        else {
            return nil
        }
        
        let frameWidthDelta = span.longitudeDelta * (frameSize.width / 360)
        let frameHeightDelta = span.latitudeDelta * (frameSize.height / 180)
        
        let adjustedLatitudeDelta = span.latitudeDelta + frameHeightDelta
        let adjustedLongitudeDelta = span.longitudeDelta + frameWidthDelta
        
        let adjustedSpan = MKCoordinateSpan(latitudeDelta: adjustedLatitudeDelta, longitudeDelta: adjustedLongitudeDelta)
        
        self.init(center: center, span: adjustedSpan)
    }
    
    // Latitude -180...180 -> 0...360
    private static func transform(c: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if c.longitude < 0 { return CLLocationCoordinate2D(latitude: c.latitude, longitude: 360 + c.longitude) }
        return c
    }
    
    // Latitude 0...360 -> -180...180
    private static func inverseTransform(c: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if c.longitude > 180 { return CLLocationCoordinate2D(latitude: c.latitude, longitude: -360 + c.longitude) }
        return c
    }
    
    private typealias Transform = (CLLocationCoordinate2D) -> (CLLocationCoordinate2D)
    
    private static func region(for coordinates: [CLLocationCoordinate2D], transform: Transform, inverseTransform: Transform) -> MKCoordinateRegion? {
        
        // handle empty array
        guard !coordinates.isEmpty else { return nil }
        
        // handle single coordinate
        guard coordinates.count > 1 else {
            return MKCoordinateRegion(center: coordinates[0], span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        }
        
        let transformed = coordinates.map(transform)
        
        // find the span
        let minLat = transformed.min { $0.latitude < $1.latitude }!.latitude
        let maxLat = transformed.max { $0.latitude < $1.latitude }!.latitude
        let minLon = transformed.min { $0.longitude < $1.longitude }!.longitude
        let maxLon = transformed.max { $0.longitude < $1.longitude }!.longitude
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)
        
        // find the center of the span
        let center = inverseTransform(CLLocationCoordinate2D(latitude: maxLat - span.latitudeDelta / 2, longitude: maxLon - span.longitudeDelta / 2))
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
