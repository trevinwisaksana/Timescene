//
//  TSEventsDataSource.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import ReSwift

protocol TSEventsDataSourceDelegate: class {
    func contentChanged()
}

final class TSEventsDataSource: StoreSubscriber {
    typealias StoreSubscriberStateType = TSAppState
    
    weak var delegate: TSEventsDataSourceDelegate?
    
    fileprivate var store: Store<TSAppState>
    fileprivate var content = [AnyObject]()
    
    init(store: Store<TSAppState>) {
        self.store = store
        
        store.subscribe(self)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    func newState(state: TSAppState) {
        
        delegate?.contentChanged()
    }
    
    func data(atIndex index: Int) -> AnyObject? {
        return content[index]
    }
    
}
