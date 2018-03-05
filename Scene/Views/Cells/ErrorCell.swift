//
//  ErrorCell.swift
//  Scene
//
//  Created by Trevin Wisaksana on 11/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class ErrorCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    func configure() {
        
        addShadow()
        containerView.roundEdges(cornerRadius: 5)
    }
    
    
}
