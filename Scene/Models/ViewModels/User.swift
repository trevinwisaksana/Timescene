//
//  User.swift
//  Makestagram
//
//  Created by Trevin Wisaksana on 03/12/2017.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

final class User: NSObject {
    
    // MARK: - Properties
    
    let id: String
    let email: String
    
    // MARK: - Init
    
    init(id: String, email: String) {
        self.id = id
        self.email = email
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Constants.UserDefaults.id) as? String, let email = aDecoder.decodeObject(forKey: Constants.UserDefaults.email) as? String else {
            return nil
        }
        
        self.id = id
        self.email = email
        
        super.init()
    }
    
    // MARK: - Singleton
    
    private static var _current: User?
    
    static var current: User? {
        
        guard let currentUser = _current else {
            return nil
        }
    
        return currentUser
    }
    
    // MARK: - Class Methods
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
}

extension User: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Constants.UserDefaults.id)
        aCoder.encode(email, forKey: Constants.UserDefaults.email)
    }
    
}


