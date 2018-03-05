//
//  EventService.swift
//  Scene
//
//  Created by Trevin Wisaksana on 27/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import EventKit
import GoogleSignIn

final class EventHelper {
    
    let eventStore = EKEventStore()
    let googleCalendarService = GoogleCalendarService()
    private var permissionGranted = false
    
    func requestAccess() {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && error == nil {
                self.permissionGranted = granted
            }
        }
    }
    
    func fetchGoogleEvents(completion: (([Event]?, Error?) -> Void)?) {
        googleCalendarService.fetchEvents { (events, error) in
            if error == nil {
                completion?(events, nil)
            } else {
                completion?(nil, error)
            }
        }
    }
    
    func retreiveEvents() -> [Event] {
        
        let calendars = eventStore.calendars(for: .event)
        var events = [Event]()
        // TODO: Change to different thread
        // TODO: Remove the for-loop after the calendar can be selected
        // TODO: Make calendar title selectable
        for calendar in calendars {
            if calendar.title == "trevin@staff.makeschool.com" {
                // Get events between the start and end of day
                let now = Date()
                if let endOfToday = Date().endOfDay {
                    let predicate = self.eventStore.predicateForEvents(withStart: now, end: endOfToday, calendars: [calendar])
                    
                    let eventsToday = self.eventStore.events(matching: predicate)
                    
                    events = eventsToday.flatMap { (event) in
                        return Event(event: event)
                    }
                }
            }
        }
        
        if events.count == 0 {
            // TODO: Error
        }
        
        return events
        
    }
    
    /*
    func createEvent() {
        if permissionGranted {
            // let event = EKEvent(eventStore: eventStore)
        }
    }
    */
    
    //---- Calendar ----//
    
    private func getCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .event)
    }
    
    func selectCalendar(from index: Int) -> EKCalendar {
        return getCalendars()[index]
    }
    
}
