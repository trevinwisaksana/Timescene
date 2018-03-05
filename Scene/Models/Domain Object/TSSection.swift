//
//  TSSection.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

struct TSSection {
    
    static func section(_ events: [TSEvent]) -> TSSection {
        return TSSection(events: events)
    }
    
    var events: [TSEvent]
    
}
