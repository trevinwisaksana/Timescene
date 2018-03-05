//
//  EventCell.swift
//  Scene
//
//  Created by Trevin Wisaksana on 21/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

final class EventCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var eventInformationView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var travelTimeContainer: UIView!
    
    var gmsMapView: GMSMapView?
    var appleMapView: MKMapView?
    
    func configure(_ data: Event, with map: MapOptions) {
        
        switch map {
        case .appleMaps:
            displayAppleMaps()
        case .googleMaps:
            displayGoogleMaps()
        default:
            fatalError("Option does not exist")
        }
        
        //---- Setup cell ----//
        
        titleLabel.text = data.title
        
        let startDate = data.startDate.getTime()
        let endDate = data.endDate.getTime()
        
        timeLabel.text = "\(startDate) – \(endDate)"
        locationLabel.text = data.locationTitle
        travelTimeLabel.text = data.timeToTravel
        
        addShadow()
        eventInformationView.addShadow()
        eventInformationView.roundEdges(cornerRadius: 5)
        
        let timeContainerHeight = travelTimeContainer.frame.height
        travelTimeContainer.roundEdges(cornerRadius: timeContainerHeight / 2)
        containerView.roundEdges(cornerRadius: 5)
        
    }
    
    func displayAppleMaps() {
        
        if gmsMapView != nil {
            gmsMapView?.removeFromSuperview()
        }
        
        let width = self.frame.width
        let height = self.frame.height * 0.62
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        appleMapView = MKMapView(frame: frame)
        appleMapView?.isUserInteractionEnabled = false
        appleMapView?.showsUserLocation = true
        
        guard let mapView = appleMapView else {
            fatalError("Failed to initialize Apple Map View")
        }
        
        mapViewContainer.addSubview(mapView)
    }
    
    func displayGoogleMaps() {
        
        if appleMapView != nil {
            appleMapView?.removeFromSuperview()
        }
        
        let width = self.frame.width
        let height = self.frame.height * 0.62
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        gmsMapView = GMSMapView(frame: frame)
        gmsMapView?.isUserInteractionEnabled = false
        gmsMapView?.isMyLocationEnabled = true
        
        guard let googleMapView = gmsMapView else {
            fatalError("Failed to initialize Google Map View")
        }
        
        mapViewContainer.addSubview(googleMapView)
    }
    
}
