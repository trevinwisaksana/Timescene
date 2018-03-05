//
//  TSAppReducer.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import ReSwift

// The reducer is responsible for evolving the application state based
// on the actions it receives
func TSAppReducer(action: Action, state: TSAppState?) -> TSAppState {
    let events = eventsReducer(action, state: state?.events)
    let settings = settingsReducer(action, state: state?.settings)
    return TSAppState(events: events, settings: settings)
}

