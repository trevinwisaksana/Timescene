//
//  GMSMapView+Camera.swift
//  Scene
//
//  Created by Trevin Wisaksana on 15/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import GoogleMaps

extension GMSMapView {
    
    func setMapViewCamera(targetCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: targetCoordinate, zoom: 15)
        self.camera = camera
        
        let bounds = GMSCoordinateBounds(coordinate: targetCoordinate, coordinate: destinationCoordinate)
        let update = GMSCameraUpdate.fit(bounds)
        self.moveCamera(update)
    }
    
    func setMapToCurrentLocation() {
        self.isMyLocationEnabled = true
    }
    
    func addMapViewDestinationMarker(coordinate: CLLocationCoordinate2D, travelTime: String) {
        let marker = GMSMarker(position: coordinate)
        marker.title = travelTime
        marker.map = self
        self.selectedMarker = marker
    }
    
}

