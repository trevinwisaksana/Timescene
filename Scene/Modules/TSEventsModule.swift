//
//  TSEventsModule.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import ReSwift

struct TSEventsLoadAction: Action {
    var events: [TSEvent]
}

func eventsReducer(_ action: Action, state: TSAppStateEvents?) -> TSAppStateEvents {
    let state = state ?? TSAppStateEvents(sections: [], lastUpdated: Date())
    
    switch action {
    case let action as TSEventsLoadAction:
        if action.events.isEmpty {
            return state
        }
        
        // let section = TSSection.section(action.events)
        
        let newSections = state.sections
        var newLastUpdated = state.lastUpdated
        
        // Logic to divide the events to different days
        /*
        if PHDateFormatter.daysAgo(section.day) == 0 {
            if let firstSection = newSections.first, firstSection.day == section.day {
                newSections[0] = section
            } else {
                newSections.insert(section, at: 0)
            }
            
            newLastUpdated = Date()
        } else {
            newSections.append(TSSection.section(action.posts))
        }
        */
        
        newLastUpdated = Date()
        
        return TSAppStateEvents(sections: newSections, lastUpdated: newLastUpdated)
        
    default:
        return state
    }
}
