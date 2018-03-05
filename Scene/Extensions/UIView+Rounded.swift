//
//  UIView+Rounded.swift
//  Scene
//
//  Created by Trevin Wisaksana on 02/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundEdges(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        // clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    func addShadow() {
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 3).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        layer.shadowOffset = CGSize.zero
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 12
    }
    
}

