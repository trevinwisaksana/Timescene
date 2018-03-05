//
//  TSLoadEventsOperation.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import ReSwift

class TSLoadEventsOperation {
    
    class func perform(_ app: Store<TSAppState>, api: TSEventAPI) {
        if api.isThereOngoingRequest {
            return
        }
        
        let operation = createOperation { (posts) in
            app.dispatch( TSEventsLoadAction(events: posts) )
        }
        
        TSEventAPIOperation.perform(app, api: api, operation: operation)
    }
    
    class func createOperation(completion: @escaping ([TSEvent]) -> ()) -> TSAPIOperationClosure {
        return { (_ api: TSEventAPI,_ errorClosure: @escaping TSAPIErrorClosure) in
            
            api.getEvents { (events, error) in
                if let error = error {
                    errorClosure(error)
                    return
                }
                
                completion(events)
            }
            
        }
    }
    
}
