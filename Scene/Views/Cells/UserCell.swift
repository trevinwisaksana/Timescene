//
//  UserCell.swift
//  Scene
//
//  Created by Trevin Wisaksana on 11/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol SignOutDelegate: class {
    func signOut()
}

protocol MapSwitchable: class {
    func switchMaps()
}

final class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailAddressLabel: UILabel!
  
    weak var signOutDelegate: SignOutDelegate?
    weak var mapSwitchableDelegate: MapSwitchable?
    
    func configure() {
        emailAddressLabel.text = User.current?.email
        
        addShadow()
        containerView.roundEdges(cornerRadius: 5)
        signOutButton.roundEdges(cornerRadius: 5)
    }
    
    @IBAction func appleMapsSwitch(_ sender: UISwitch) {
        if sender.isOn {
            MapOptions.set(.appleMaps)
        } else {
            MapOptions.set(.googleMaps)
        }
        
        mapSwitchableDelegate?.switchMaps()
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        if let delegate = signOutDelegate {
            delegate.signOut()
        }
    }

}
