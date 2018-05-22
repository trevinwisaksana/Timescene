//
//  TSEventsAPI.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn

final class EventAPI {
    
    private let googleCalendarService = GTLRCalendarService()
    
    fileprivate(set) var isThereOngoingRequest = false
    
    func getEvents(_ completion: @escaping APIEventCompletion) {
        getEvents(retries: 10, completion)
    }
    
    fileprivate func getEvents(retries: Int, _ completion: @escaping APIEventCompletion) {
        
        isThereOngoingRequest = true
        
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        
        guard let endOfDay = Date().endOfDay else {
            return
        }
        
        query.timeMin = GTLRDateTime(date: Date())
        query.timeMax = GTLRDateTime(date: endOfDay)
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        
        googleCalendarService.executeQuery(query) { (ticket, response, error) in
            
            if let error = error {
                self.isThereOngoingRequest = false
                completion([Event](), error)
            }
            
            guard let calendarEvents = (response as! GTLRCalendar_Events).items else {
                return
            }
            
            let events = calendarEvents.compactMap { (event) in
                return Event(googleEvent: event)
            }
            
            self.isThereOngoingRequest = false
            completion(events, nil)
        }
    }

}
