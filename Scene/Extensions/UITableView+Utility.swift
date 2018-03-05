//
//  UITableView+Utility.swift
//  Scene
//
//  Created by Trevin Wisaksana on 04/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension CellIdentifiable where Self: UITableViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: CellIdentifiable { }

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier) as? T else {
            fatalError("Error dequeuing cell for identifier \(T.cellIdentifier)")
        }
        
        return cell
    }
    
}
