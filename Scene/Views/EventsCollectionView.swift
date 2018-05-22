//
//  EventsCollectionView.swift
//  Scene
//
//  Created by Trevin Wisaksana on 02/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class EventsCollectionView: UICollectionView {
    
    //---- Properties ----//
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    // For animation
    var animatedCellIndexPath = [IndexPath]()
    var hasBeenAnimated = false
    var isExpanded = false
    
    //---- Register Cell ----//
    
    func registerCollectionViewCellNib() {
        register(EventCell.self)
        register(InformationCell.self)
        register(GoogleSignInCell.self)
        register(UserCell.self)
        register(ErrorCell.self)
        register(NoEventCell.self)
        register(WelcomeCell.self)
    }
 
    //---- Cell Animation ----//
 
    func animateCellRemoval(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if !animatedCellIndexPath.contains(indexPath) {
            
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell.layer.opacity = 1
            
            let delay = 0.06 * Double(indexPath.row)
            UIView.animate(withDuration: 0.8, delay: delay , usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                cell.layer.opacity = 0
            })
            
            animatedCellIndexPath.append(indexPath)
        }
    }
    
    func animateCellEntry(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if !animatedCellIndexPath.contains(indexPath) {
            
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            cell.layer.opacity = 0.0
            
            let delay = 0.06 * Double(indexPath.row)
            UIView.animate(withDuration: 0.8, delay: delay , usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell.layer.opacity = 1
            })
            
            animatedCellIndexPath.append(indexPath)
        }
    }
    
    func expandCell(at indexPath: IndexPath) {
        
        isExpanded = !isExpanded
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            let section: IndexSet = [4]
            self.reloadSections(section)
        }, completion: { (success) in
            self.scrollToItem(at: indexPath, at: .bottom, animated: false)
        })
        
    }
    
    //---- Activity Indicator ----//
    
    func addActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        backgroundView = activityIndicatorView
    }
    
    func animateActivityIndicatorView() {
        activityIndicatorView?.startAnimating()
    }
    
    func stopActivityIndicatorAnimation() {
        activityIndicatorView?.stopAnimating()
    }
    
    //---- No Events Condition ----//
    
    func showNoEventMessage() {
        let label = UILabel()
        label.frame.size = CGSize(width: 100, height: 50)
        label.text = "No upcoming events found."
        label.textAlignment = .center
        label.center = self.center
        
        self.backgroundView = label
    }
    
    //---- Cell Sizing ----//
    
    func determineCellSize(for indexPath: IndexPath, isEventsEmpty: Bool) -> CGSize {
        
        let view = UIScreen.main.bounds
        let width = view.width * 0.9
        let section = indexPath.section
        
        switch section {
        case 0:
            let height = view.height * 0.07
            return CGSize(width: width, height: height)
        case 1:
            let height = view.height * 0.2
            return CGSize(width: width, height: height)
        case 2:
            let height = view.height * 0.2
            return CGSize(width: width, height: height)
        case 3:
            return resizeNoEventsCell(eventsIsEmpty: isEventsEmpty)
        case 4:
            
            if isExpanded {
                let height = view.height * 0.3
                return CGSize(width: width, height: height)
            } else {
                let height = view.height * 0.07
                return CGSize(width: width, height: height)
            }
            
        default:
            return CGSize.zero
        }
        
    }
    
    func resizeNoEventsCell(eventsIsEmpty: Bool) -> CGSize {
        let view = UIScreen.main.bounds
        let width = view.width * 0.9
        
        if eventsIsEmpty {
            let height = view.height * 0.2
            return CGSize(width: width, height: height)
        } else {
            let height = view.height * 0.48
            return CGSize(width: width, height: height)
        }
    }
    
    func setCellSpacing(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 30
        case 2:
            return 0
        case 3:
            return 40 // Spacing between each event cell
        case 4:
            return 0
        default:
            return 0
        }
    }
    
    func setCellInset(for section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        case 1:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 2:
            return UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        case 3:
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        case 4:
            return UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        default:
            return UIEdgeInsets.zero
        }
    }

    
}
