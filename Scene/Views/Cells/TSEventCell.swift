//
//  TSEventCell.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class TSEventCell: UICollectionViewCell {
    
    fileprivate var event: TSEvent?
    fileprivate var model: TSEventViewModel?
    
    class func view(_ collectionView: UICollectionView, indexPath: IndexPath, subject: AnyObject?) -> UICollectionViewCell {
        let view: TSEventCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let event = subject as? TSEvent {
            view.setEvent(event)
        }
        
        return view
    }
    
    fileprivate func setEvent(_ event: TSEvent?) {
        self.event = event
        
        guard let event = event else {
            return
        }
        
        model = TSEventViewModel(withEvent: event, store: mainStore)
        updateUI()
    }
    
    fileprivate func updateUI() {
        guard let model = model else {
            return
        }
        
//        layer?.backgroundColor = mouseInside ? NSColor.ph_highlightColor().cgColor : NSColor.ph_whiteColor().cgColor
//
//        seenView.isHidden = model.isSeen
//
//        titleLabel.stringValue          = model.title
//        taglineLabel.stringValue        = model.tagline
//        voteCountLabel.stringValue      = model.votesCount
//        commentsCountLabel.stringValue  = model.commentsCount
//        timeAgoLabel.stringValue        = model.createdAt
//
//        thumbnailImageView.kf.setImage(with: model.thumbnailUrl, placeholder: NSImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
//
//        twitterButton.isHidden = !mouseInside
//        facebookButton.isHidden = !mouseInside
    }
    
}
