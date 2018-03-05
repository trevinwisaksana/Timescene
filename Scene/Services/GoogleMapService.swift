//
//  GoogleMapService.swift
//  Scene
//
//  Created by Trevin Wisaksana on 27/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import CoreLocation
import Alamofire
import GoogleMaps
import SwiftyJSON

struct GoogleMapService {
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation, travelMode: TravelMode, completion: (([JSON]?, Error?) -> Void)?) {
        
        let origin = startLocation.coordinate
        let destination = endLocation.coordinate
        
        let urlRequest = TSRouter.getDirections(origin: origin, destination: destination, mode: travelMode)
        
        DispatchQueue.global(qos: .background).async {
            Alamofire.request(urlRequest).validate().responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    
                    let jsonData = JSON(data)
                    
                    guard let routes = jsonData["routes"].array else {
                        return
                    }
                    
                    completion?(routes, nil)
                    
                case .failure(let error):
                    completion?(nil, error)
                }
            }
        }
    }
    
    func calculateTravelTime(travel: Travel, completion: ((String?, CLLocation?, Error?) -> Void)?) {
        
        let urlRequest = TSRouter.getTravelDuration(for: travel)
        
        DispatchQueue.global(qos: .background).async {
            Alamofire.request(urlRequest).validate().responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    
                    guard let geocodedWaypoints = JSON(data)["routes"].array else {
                        print("Cannot find geocoded waypoints")
                        let error = NSError(domain: "Cannot find geocoded waypoints", code: 0, userInfo: nil)
                        completion?(nil, nil, error)
                        return
                    }
                    
                    guard let routes = geocodedWaypoints.first else {
                        print("Cannot find routes")
                        let error = NSError(domain: "Cannot find routes", code: 1, userInfo: nil)
                        completion?(nil, nil, error)
                        return
                    }
                    
                    guard let legs = routes["legs"].array else {
                        print("Cannot find legs")
                        let error = NSError(domain: "Cannot find legs", code: 2, userInfo: nil)
                        completion?(nil, nil, error)
                        return
                    }
                    
                    let estimatedTravelTime = legs[0]["duration_in_traffic"]["text"].string
                    let beautifiedText = estimatedTravelTime?.replacingOccurrences(of: "mins", with: "minutes")
                    
                    let endLocation = legs[0]["end_location"]
                    let latitude = endLocation["lat"].doubleValue
                    let longitude = endLocation["lng"].doubleValue
                    
                    let destination = CLLocation(latitude: latitude, longitude: longitude)
                    
                    completion?(beautifiedText, destination, nil)
                    
                case .failure(let error):
                    completion?(nil, nil, error)
                }
            }
        }
    }
    
}
