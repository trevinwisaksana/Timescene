//
//  TSCallbacks.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

typealias VoidCallback = () -> Void
typealias APIErrorClosure = (_ error: Error) -> ()
typealias APIOperationClosure = (_ api: EventAPI,_ errorClosure: @escaping APIErrorClosure) -> ()
typealias APITravelCompletion = ((_ travel: Travel, _ error: Error?) -> ())
typealias APIEventCompletion   = ((_ events: [Event], _ error: Error?) -> ())

