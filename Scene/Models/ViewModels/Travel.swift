//
//  Travel.swift
//  Test Project
//
//  Created by Trevin Wisaksana on 6/26/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import CoreLocation

enum TravelMode: String {
    case `default`, driving, walking, transit
}

final class Travel {
    
    var currentLocation: String
    var destination: String
    var departureTime = Int(Date().timeIntervalSince1970 * 1000)
    var mode: String
    
    init(currentLocation: String, destination: String, mode: TravelMode) {
        
        self.currentLocation = currentLocation.replacingOccurrences(of: " ", with: "+")
        self.destination = destination.replacingOccurrences(of: " ", with: "+")
        self.mode = mode.rawValue
    }
    
}

