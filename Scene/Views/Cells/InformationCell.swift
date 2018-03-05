//
//  InformationCell.swift
//  Scene
//
//  Created by Trevin Wisaksana on 06/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class InformationCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    func configure() {
        
        
        
        addShadow()
        containerView.roundEdges(cornerRadius: 5)
        
    }
    
}

