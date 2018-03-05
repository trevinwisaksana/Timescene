//
//  TSEventsViewModel.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import ReSwift

final class TSEventViewModel {
    
    fileprivate var event: TSEvent
    fileprivate var store: Store<TSAppState>
    
    var title: String {
        return event.title
    }
    
    init(withEvent event: TSEvent, store: Store<TSAppState>) {
        self.event = event
        self.store = store
    }
    
}
