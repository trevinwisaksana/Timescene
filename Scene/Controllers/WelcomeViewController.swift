//
//  WelcomeViewController.swift
//  Scene
//
//  Created by Trevin Wisaksana on 02/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        let eventsViewController = UIStoryboard.initialViewController(for: .container)
        present(eventsViewController, animated: true, completion: nil)
    }
    
}
