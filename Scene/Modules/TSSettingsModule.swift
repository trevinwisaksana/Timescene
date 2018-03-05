//
//  TSSettingsModule.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import ReSwift

struct TSSettings {
    var autologinEnabled: Bool
    var showsAppleMaps: Bool
    var filterCount: Int
}

struct TSSettingsSetAction: Action {
    var settings: TSSettings
}

struct TSSettingsActionAutoLogin: Action {
    var autologin: Bool
}

struct TSSettingsActionShowsAppleMaps: Action {
    var showsAppleMaps: Bool
}

struct TSSettingsActionFilterCount: Action {
    var filterCount: Int
}

func settingsReducer(_ action: Action, state: TSSettings?) -> TSSettings {
    var state = state ?? TSSettings(autologinEnabled: true, showsAppleMaps: true, filterCount: 10)
    
    switch action {
        
    case let action as TSSettingsSetAction:
        return action.settings
        
    case let action as TSSettingsActionAutoLogin:
        state.autologinEnabled = action.autologin
        
        return state
        
    case let action as TSSettingsActionShowsAppleMaps:
        state.showsAppleMaps = action.showsAppleMaps
        
        return state

    case let action as TSSettingsActionFilterCount:
        state.filterCount = action.filterCount
        
        return state
        
    default:
        return state
    }
}

