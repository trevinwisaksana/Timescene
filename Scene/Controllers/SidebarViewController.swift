//
//  SidebarViewController.swift
//  Scene
//
//  Created by Trevin Wisaksana on 24/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}

// MARK: Table View Data Source
extension SidebarViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SidebarCell = tableView.dequeueReusableCell()
        let row = indexPath.row
        
        switch row {
        case 0:
            break
        case 1:
            break
        default:
            fatalError("Index out of range.")
        }
        
        return cell
    }

}

// Mark: Table View Delegate

extension SidebarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
