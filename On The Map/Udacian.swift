//
//  Udacian.swift
//  On The Map
//
//  Created by Bryan Morfe on 2/4/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import Foundation

struct Udacian {
    
    // MARK: Properties
    
    var firstName: String
    var lastName: String
    
    // MARK: Initializer
    
    init(with dictionary: [String: AnyObject]) throws {
    
        // Gather data or throw error
        
        guard let user = dictionary[Udacity.Constant.JSONResponseKey.user] as? [String: AnyObject] else {
            let userInfo = [NSLocalizedDescriptionKey: "No users found in dictionary. \(dictionary)"]
            throw(NSError(domain: "Udacian:init", code: 1, userInfo: userInfo))
        }
        
        guard let firstName = user[Udacity.Constant.JSONResponseKey.firstName] as? String else {
            let userInfo = [NSLocalizedDescriptionKey: "No first name found in user. \(user)"]
            throw(NSError(domain: "Udacian:init", code: 1, userInfo: userInfo))
        }
        
        guard let lastName = user[Udacity.Constant.JSONResponseKey.lastName] as? String else {
            let userInfo = [NSLocalizedDescriptionKey: "No last name found in user. \(user)"]
            throw(NSError(domain: "Udacian:init", code: 1, userInfo: userInfo))
        }
        
        // Initialize Properties
        
        self.firstName = firstName
        self.lastName = lastName
    }
}
