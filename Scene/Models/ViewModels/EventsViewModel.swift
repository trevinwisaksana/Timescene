//
//  EventsViewModel.swift
//  Scene
//
//  Created by Trevin Wisaksana on 27/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GoogleMaps
import MapKit

final class EventsViewModel: NSObject {
    
    //---- Properties ----//
    
    enum CalendarSource {
        case apple
        case google
    }
    
    private var events = [Event]()
    
    var currentLocation: Location?
    var userEmail: String?
    
    var destinationCoordinate: CLLocation?
    var startLocation: CLLocation?
    var destination: CLLocation?
    
    var locationHelper = LocationHelper()
    let eventHelper = EventHelper()
    
    //---- User ----//
    
    func setCurrentUser(id: String, email: String) {
        let currentUser = User(id: id, email: email)
        User.setCurrent(currentUser, writeToUserDefaults: true)
    }
    
    //---- Events ----//
    
    func getEventsToday(from calendar: CalendarSource) {
        switch calendar {
        case .apple:
            events = eventHelper.retreiveEvents()
        case .google:
            break
        }
    }
    
    func getGoogleEvents(completion: ((Error?) -> Void)?) {
        eventHelper.fetchGoogleEvents { (googleEvents, error) in
            if error == nil {
                
                guard let googleEvents = googleEvents else {
                    completion?(error)
                    return
                }
                
                self.events = googleEvents
                completion?(nil)
                
            } else {
                completion?(error)
            }
        }
    }
    
    func event(at indexPath: IndexPath) -> Event {
        return events[indexPath.row]
    }
    
    func numberOfEvents() -> Int {
        return events.count
    }
    
    func removeEvents() {
        events.removeAll()
    }
    
    func getTravelTime(for event: Event, success: @escaping (Bool) -> Void) {
        
        guard let destinationTitle = event.locationTitle else {
            event.locationTitle = "Location not included."
            event.timeToTravel = "-- minutes"
            success(false)
            return
        }
        
        locationHelper.getTravelTime(currentLocation: currentLocation, targetDestination: destinationTitle) { (estimatedTravelTime, destination, error) in
            
            if let _ = error {
                event.timeToTravel = "-- minutes"
                success(false)
            }
            
            if let timeToTravel = estimatedTravelTime, let destination = destination {
                event.timeToTravel = timeToTravel
                event.location = destination
                success(true)
            }
        }
    }
    
    /// For GMSMapView
    func displayPath(for event: Event, on googleMapView: GMSMapView, success: @escaping (Bool) -> Void) {
        
        guard let destination = event.location else {
            return
        }
        
        guard let currentLocation = currentLocation?.clLocation() else {
            return
        }
        
        guard let travelTime = event.timeToTravel else {
            return
        }
        
        let currentCoordinate = currentLocation.coordinate
        let destinationCoordinate = destination.coordinate
        
        locationHelper.drawPath(startLocation: currentLocation, destination: destination, travelMode: .driving, mapView: googleMapView) { (error) in
            if let _ = error {
                success(false)
            }
            
            googleMapView.setMapViewCamera(targetCoordinate: currentCoordinate, destinationCoordinate: destinationCoordinate)
            googleMapView.addMapViewDestinationMarker(coordinate: destinationCoordinate, travelTime: travelTime)
            
            success(true)
        }
    }
    
    /// For MKMapView
    func displayPath(for event: Event, on appleMapView: MKMapView, success: @escaping (Bool) -> Void) {
        
        guard let destination = event.location else {
            return
        }
        
        guard let currentLocation = currentLocation?.clLocation() else {
            return
        }
        
        guard let travelTime = event.timeToTravel else {
            return
        }
        
        guard let locationTitle = event.locationTitle else {
            return
        }
        
        let currentCoordinate = currentLocation.coordinate
        let destinationCoordinate = destination.coordinate
        
        let request = MKDirectionsRequest()
        
        let placemark = MKPlacemark(coordinate: currentCoordinate, addressDictionary: nil)
        request.source = MKMapItem(placemark: placemark)
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            
            guard let unwrappedResponse = response else {
                return
            }
            
            if unwrappedResponse.routes.count > 0 {
                
                let polyline = unwrappedResponse.routes[0].polyline
                
                appleMapView.add(polyline)
                
                let height = polyline.boundingMapRect.size.height * 1.3
                let width = polyline.boundingMapRect.size.width * 1.2
                let mapSize = MKMapSize(width: width, height: height)
                
                let x = polyline.boundingMapRect.origin.x + (width * -0.1)
                let y = polyline.boundingMapRect.origin.y + (height * -0.1)
                let origin = MKMapPoint(x: x, y: y)
                
                let mapFrame = MKMapRect(origin: origin, size: mapSize)
                
                appleMapView.setVisibleMapRect(mapFrame, animated: true)
                
                let annotation = MapPin(coordinate: destinationCoordinate, title: locationTitle, subtitle: travelTime)
                appleMapView.addAnnotation(annotation)
                
            }
        }
        
    }
    
    //---- Location ----//
    
    func getCurrentLocation(completion: ((Error?) -> Void)?) {
        locationHelper.getCurrentLocation { (location, error) in
            if error == nil {
                guard let location = location else {
                    print("Failed to get location")
                    return
                }
                self.currentLocation = location
                completion?(nil)
            } else {
                completion?(error)
                print("Can't get location")
            }
        }
    }
    
}
