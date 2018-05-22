//
//  Location.swift
//  Test Project
//
//  Created by Trevin Wisaksana on 6/26/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import CoreLocation

struct Location: Equatable {

    var subLocality: String
    var thoroughfare: String
    var locality: String
    var country: String
    var postalCode: String
    var coordinate: CLLocationCoordinate2D
    
    init?(placemark: CLPlacemark) {
        
        guard let coordinate = placemark.location?.coordinate else {
            return nil
        }
        
        guard let subLocality = placemark.subLocality else {
            return nil
        }
        
        guard let thoroughfare = placemark.thoroughfare else {
            return nil
        }
        
        guard let locality = placemark.locality else {
            return nil
        }
        
        guard let country = placemark.country else {
            return nil
        }
        
        guard let postalCode = placemark.postalCode else {
            return nil
        }
        
        self.coordinate = coordinate
        self.country = country
        self.subLocality = subLocality
        self.thoroughfare = thoroughfare
        self.locality = locality
        self.postalCode = postalCode
        
    }
    
    // Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        if lhs.thoroughfare == rhs.thoroughfare {
            return true
        } else {
            return false
        }
    }
    
    func clLocation() -> CLLocation {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
}
