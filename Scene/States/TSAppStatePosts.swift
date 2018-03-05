//
//  TSAppStatePosts.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import ReSwift

struct TSAppStateEvents {
    
    var sections: [TSSection]

    var todayEvents: [TSEvent]?  {
        guard let section = sections.first else  {
            return nil
        }
        
        return section.events
    }
    
    var lastUpdated: Date
    
}
