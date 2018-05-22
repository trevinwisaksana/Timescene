//
//  TSLoadingView.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

enum LoadingState {
    case loading, error, empty, idle
}

class TSLoadingView: UIView {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var reload: UIButton!
    
    var state: LoadingState = .idle {
        didSet {
            switch state {
            case .loading:
                isHidden = false
                reload.isHidden = true
                loadingIndicator.isHidden = false
                loadingIndicator.startAnimating()
                loadingLabel.text = "Hunting down new posts..."
                
            case .error:
                isHidden = false
                reload.isHidden = false
                loadingIndicator.isHidden = true
                loadingIndicator.stopAnimating()
                loadingLabel.text = "Something went wrong 😿"
                
            case .empty:
                isHidden = false
                reload.isHidden = false
                loadingIndicator.isHidden = true
                loadingIndicator.stopAnimating()
                loadingLabel.text = "Nothing to show 😿"
                
            case .idle:
                isHidden = true
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.white
    }
    
    @IBAction func toggleReloadButton(_ sender: UIView) {
        state = .loading
        // PHLoadPostOperation.performNewer()
    }
}
