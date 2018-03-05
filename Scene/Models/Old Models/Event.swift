//
//  Event.swift
//  Scene
//
//  Created by Trevin Wisaksana on 27/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import EventKit
import GoogleAPIClientForREST

final class Event {
    
    var title: String
    var locationTitle: String?
    var location: CLLocation?
    var startDate = Date()
    var endDate = Date()
    var timeToTravel: String?
    
    init(event: EKEvent) {
        
        let locationTitle = event.location?.replacingOccurrences(of: "\n", with: " ")
        
        self.title = event.title
        self.locationTitle = locationTitle ?? "Location not included"
        self.startDate = event.startDate
        self.endDate = event.endDate
        
    }
    
    init(googleEvent: GTLRCalendar_Event) {
        
        self.title = googleEvent.summary ?? ""
        self.locationTitle = googleEvent.location
        
        guard let startDate = googleEvent.start?.dateTime?.date else {
            return
        }
        
        guard let endDate = googleEvent.end?.dateTime?.date else {
            return
        }
        
        self.startDate = startDate
        self.endDate = endDate
        
    }
    
}
