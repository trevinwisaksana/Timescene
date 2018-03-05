//
//  MapOptions.swift
//  Scene
//
//  Created by Trevin Wisaksana on 25/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

struct MapOptions: OptionSet {
    
    let rawValue: Int
    
    static let appleMaps = MapOptions(rawValue: 1 << 0)
    static let googleMaps  = MapOptions(rawValue: 1 << 1)
    
    private static var _current: MapOptions?
    
    static var current: MapOptions? {
        
        guard let currentMap = _current else {
            return nil
        }
        
        return currentMap
    }
    
    static func set(_ map: MapOptions, writeToUserDefaults: Bool = false) {
        /*
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        */
        
        _current = map
    }
    
    
}
