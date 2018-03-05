//
//  MapAnnotation.swift
//  Scene
//
//  Created by Trevin Wisaksana on 25/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import MapKit

final class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
