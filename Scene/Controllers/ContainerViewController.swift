//
//  EventsViewController.swift
//  Scene
//
//  Created by Trevin Wisaksana on 11/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import QuartzCore

final class ContainerViewController: UIViewController {
    
    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }
    
    var centerNavigationController: UINavigationController!
    var centerViewController: EventsViewController!
    var leftViewController: SidebarViewController?
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = (currentState != .bothCollapsed)
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    private var centerPanelExpandedOffset: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        // Wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.isNavigationBarHidden = true
        centerNavigationController.didMove(toParentViewController: self)
        centerPanelExpandedOffset = view.frame.width / 2
        
    }
    
}

private extension UIStoryboard {
    
    static func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static func leftViewController() -> SidebarViewController? {
        return UIStoryboard(type: .sidebar).instantiateInitialViewController() as? SidebarViewController
    }
    
    static func centerViewController() -> EventsViewController? {
        return mainStoryboard().instantiateInitialViewController() as? EventsViewController
    }
    
}


// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }

    func addLeftPanelViewController() {
        guard leftViewController == nil else { return }
        
        if let vc = UIStoryboard.leftViewController() {
            addChildSidePanelController(vc)
            leftViewController = vc
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: SidebarViewController) {
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
  
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(targetPosition: centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.6
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}
