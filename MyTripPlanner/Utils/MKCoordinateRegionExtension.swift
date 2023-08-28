//
//  MKCoordinateRegionExtension.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 28/08/2023.
//

import Foundation
import MapKit
import SwiftUI

extension MKCoordinateRegion {
    
    // Initialisateur pour prendre en compte la taille de la vue
    init?(coordinates: [CLLocationCoordinate2D], zoomPercentage: Double, frameSize: CGSize) {
        let primeRegion = MKCoordinateRegion.region(for: coordinates, transform: { $0 }, inverseTransform: { $0 }, zoomPercentage: zoomPercentage)
        
        let transformedRegion = MKCoordinateRegion.region(for: coordinates, transform: MKCoordinateRegion.transform, inverseTransform: MKCoordinateRegion.inverseTransform, zoomPercentage: zoomPercentage)
        
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
        
        let adjustedLatitudeDelta = span.latitudeDelta * (1 + zoomPercentage / 100) + frameHeightDelta
        let adjustedLongitudeDelta = span.longitudeDelta * (1 + zoomPercentage / 100) + frameWidthDelta
        
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
    
    private static func region(for coordinates: [CLLocationCoordinate2D], transform: Transform, inverseTransform: Transform, zoomPercentage: Double) -> MKCoordinateRegion? {
        
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
        
        // Adjust the span by zoom percentage
        let adjustedLatitudeDelta = span.latitudeDelta * (1 + zoomPercentage / 100)
        let adjustedLongitudeDelta = span.longitudeDelta * (1 + zoomPercentage / 100)
        
        let adjustedSpan = MKCoordinateSpan(latitudeDelta: adjustedLatitudeDelta, longitudeDelta: adjustedLongitudeDelta)
        
        return MKCoordinateRegion(center: center, span: adjustedSpan)
    }
}
