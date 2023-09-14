//
//  ExtensionPlacemark.swift
//  MyTripPlanner
//
//  Created by Antoine Omnès on 24/08/2023.
//

import Foundation
import CoreLocation

extension CLPlacemark {
#if os(visionOS)

    func getPerfectDistance() -> Double {
        var distance: Double =  10000
        
        if self.thoroughfare != nil {
            distance = 1000
        } else if self.locality != nil {
            distance = 10000
        } else if self.country != nil  {
            distance = 100000000
        }
        
        return distance
    }
    
#elseif os(iOS)
    
    func getPerfectDistance() -> Double {
        var distance: Double =  10000
        if self.thoroughfare != nil {
            distance = 1000
        } else if self.locality != nil {
            distance = 10000
        } else if self.region != nil  {
            distance = 100000
        } else if self.country != nil  {
            distance = 100000000
        }
        return distance
    }
    
#endif

}
