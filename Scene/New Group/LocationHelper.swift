//
//  LocationHelper.swift
//  Scene
//
//  Created by Trevin Wisaksana on 28/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import CoreLocation
import SwiftLocation
import GoogleMaps

struct LocationHelper {
    
    let googleMapService = GoogleMapService()

    func requestAuthorization() {
        if Locator.authorizationStatus == .notDetermined {
            Locator.requestAuthorizationIfNeeded(.whenInUse)
        } else if Locator.authorizationStatus == .denied {
            Locator.requestAuthorizationIfNeeded(.whenInUse)
        }
    }
    
    func getCurrentLocation(completion: ((Location?, Error?) -> Void)?) {

        guard let timeInterval = TimeInterval(exactly: 30) else { return }
        let timeout = Timeout.after(timeInterval)
        
        Locator.currentPosition(accuracy: .block, timeout: timeout, onSuccess: { (location) in
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                guard let placemark = placemarks?[0] else { return }
                let location = Location(placemark: placemark)
                completion?(location, nil)
            }
        }) { (error, location) in
            completion?(nil, error)
        }
    }
    
    func subscribeLocationUpdates(completion: ((Location?, Error?) -> Void)?) {
        Locator.subscribePosition(accuracy: .block, onUpdate: { (location) in
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                guard let placemark = placemarks?[0] else { return }
                let location = Location(placemark: placemark)
                completion?(location, nil)
            }
        }) { (error, location) in
            completion?(nil, error)
        }
    }
    
    func unsubscribeLocationUpdates() {
        Locator.completeAllLocationRequests()
    }
    
    func getTravelTime(currentLocation: Location?, targetDestination: String, completion: ((String?, CLLocation?, Error?) -> Void)?) {
        
        guard let currentLocation = currentLocation else {
            return
        }
        
        let subLocality = currentLocation.subLocality
        let thoroughfare = currentLocation.thoroughfare
        let locality = currentLocation.locality
        let country = currentLocation.country
        let postalCode = currentLocation.postalCode
        
        let address = "\(subLocality) \(thoroughfare) \(locality) \(country) \(postalCode)"
        
        let travelData = Travel(currentLocation: address, destination: targetDestination, mode: .driving)
        
        self.googleMapService.calculateTravelTime(travel: travelData) { (estimatedTravelTime, destination, error) in
            if error == nil {
                completion?(estimatedTravelTime, destination, nil)
            } else {
                completion?(nil, nil, error)
            }
        }
    }
    
    func drawPath(startLocation: CLLocation, destination: CLLocation, travelMode: TravelMode, mapView: GMSMapView, completion: ((Error?) -> Void)?) {
        self.googleMapService.drawPath(startLocation: startLocation, endLocation: destination, travelMode: .driving) { (routes, error) in
            
            if error == nil {
                
                guard let routes = routes else {
                    return
                }
                
                DispatchQueue.main.async {
                    for route in routes {
                        let routeOverviewPolyline = route["overview_polyline"].dictionary
                        guard let points = routeOverviewPolyline?["points"]?.string else {
                            return
                        }
                        
                        let path = GMSPath.init(fromEncodedPath: points)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeWidth = 8
                        polyline.geodesic = true
                        polyline.strokeColor = UIColor(red: 0/255, green: 162/255, blue: 255/255, alpha: 1)
                        
                        polyline.map = mapView
                    
                    }
                }
                
                completion?(nil)
                
            } else {
                completion?(error)
            }
        }
    }
    
}
