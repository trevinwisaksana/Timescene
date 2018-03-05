//
//  TSTravel.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

final class TSTravel {
    
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
