//
//  GoogleSignInCell.swift
//  Scene
//
//  Created by Trevin Wisaksana on 09/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class GoogleSignInCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    func configure() {
        
        
        
        addShadow()
        containerView.roundEdges(cornerRadius: 5)
        
    }
    
}
