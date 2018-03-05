//
//  MapView+Camera.swift
//  Scene
//
//  Created by Trevin Wisaksana on 25/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import MapKit

extension MKMapView {
    
    func setMapViewCamera(currentCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let camera = MKMapCamera(lookingAtCenter: currentCoordinate, fromEyeCoordinate: destinationCoordinate, eyeAltitude: 100.0)
        self.setCamera(camera, animated: true)
    }
    
    /*
    func addMapViewDestinationMarker(coordinate: CLLocationCoordinate2D, travelTime: String) {
        let marker = GMSMarker(position: coordinate)
        marker.title = travelTime
        marker.map = self
        self.selectedMarker = marker
    }
    */
    
}
