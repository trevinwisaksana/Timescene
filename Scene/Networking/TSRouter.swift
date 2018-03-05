//
//  Router.swift
//  Test Project
//
//  Created by Trevin Wisaksana on 6/21/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Alamofire
import CoreLocation

enum TSRouter: URLRequestConvertible {
    
    static private let baseURL = "https://maps.googleapis.com/"
    
    case getTravelDuration(for: Travel)
    case getDirections(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, mode: TravelMode)
    
    var method: HTTPMethod {
        switch self {
        case .getTravelDuration, .getDirections:
            return .get
        default:
            fatalError("Error: Unrecognized HTTP Method")
        }
    }
    
    var path: String {
        switch self {
        case .getTravelDuration, .getDirections:
            return "maps/api/directions/json"
        default:
            fatalError("Error: Unrecognized path")
        }
    }
        
    public func asURLRequest() throws -> URLRequest {
        
        // Set the URL-parameters
        let parameters: [String: Any] = {
            switch self {
            case .getTravelDuration(let travelData):
                
                let origin = travelData.currentLocation
                let destination = travelData.destination
                let mode = travelData.mode
                let departureTime = travelData.departureTime
                
                return ["origin": origin,
                        "destination": destination,
                        "departure_time": departureTime,
                        "mode": mode,
                        "trafic_model": "best_guess",
                        "key": Constants.Key.googleMapsAPI]
                
            case .getDirections(let origin, let destination, let travelMode):
                
                let origin = "\(origin.latitude), \(origin.longitude)"
                let destination = "\(destination.latitude), \(destination.longitude)"
                
                return ["origin": origin,
                        "destination": destination,
                        "mode": travelMode]
                
            default:
                return [:]
            }
        }()
        
        // Sets as a URL
        let url = try TSRouter.baseURL.asURL()
        // Creating a request
        var request = URLRequest(url: url.appendingPathComponent(path))
        // Mutates the request to change the HTTPRequest method
        request.httpMethod = method.rawValue
        
        return try URLEncoding.queryString.encode(request, with: parameters)
    }
}
