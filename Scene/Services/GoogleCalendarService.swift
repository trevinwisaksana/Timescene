//
//  GoogleCalendarService.swift
//  Scene
//
//  Created by Trevin Wisaksana on 27/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn

protocol CalendarUpdatable {
    func displayResultWithTicket(_ ticket: GTLRServiceTicket, finishedWithObject response: GTLRCalendar_Events, error: NSError?)
}

struct GoogleCalendarService {
    private let googleCalendarService = GTLRCalendarService()
    
    func authenticate(_ user: GIDGoogleUser) {
        googleCalendarService.authorizer = user.authentication.fetcherAuthorizer()
    }
    
    func fetchEvents(completion: (([Event]?, Error?) -> Void)?) {
        
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        
        // Add timeMax
        query.timeMin = GTLRDateTime(date: Date())
        
        guard let endOfDay = Date().endOfDay else {
            return
        }
        
        query.timeMax = GTLRDateTime(date: endOfDay)
        
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        
        self.googleCalendarService.executeQuery(query) { (ticket, response, error) in
            if error == nil {
                
                guard let calendarEvents = (response as! GTLRCalendar_Events).items else {
                    return
                }
                
                let events = calendarEvents.flatMap { (event) in
                    return Event(googleEvent: event)
                }
                
                completion?(events, nil)
                
            } else {
                completion?(nil, error)
            }
        }
    }
    
}
