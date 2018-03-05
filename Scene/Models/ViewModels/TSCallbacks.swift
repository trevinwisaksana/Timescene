//
//  TSCallbacks.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

typealias TSVoidCallback = () -> Void
typealias TSAPIErrorClosure = (_ error: Error) -> ()
typealias TSAPIOperationClosure = (_ api: TSEventAPI,_ errorClosure: @escaping TSAPIErrorClosure) -> ()
typealias TSAPITravelCompletion = ((_ travel: TSTravel, _ error: Error?) -> ())
typealias TSAPIEventCompletion   = ((_ events: [TSEvent], _ error: Error?) -> ())
