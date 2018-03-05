//
//  ForwardPipe.swift
//  Scene
//
//  Created by Trevin Wisaksana on 18/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

precedencegroup ForwardPipe {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator |> : ForwardPipe

public func |> <T, U>(value: T, function: ((T) -> U)) -> U {
    return function(value)
}
