//
//  StudentInformation.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/29/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit

struct StudentInformation {
    
    // MARK: Properties
    
    var objectID: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
    // MARK: Initializer
    
    init(with dictionary: [String: AnyObject]) throws {
        
        // Check that all data is there
        guard let objectID = dictionary[Parse.Constant.JSONResponseKey.objectID] as? String else {
            let userInfo = [NSLocalizedDescriptionKey: "The property \"objectID\" could not be initialized"]
            throw(NSError(domain: "init", code: 1, userInfo: userInfo))
        }
        
        guard let uniqueKey = dictionary[Parse.Constant.JSONResponseKey.uniqueKey] as? String else {
            let userInfo = [NSLocalizedDescriptionKey: "The property \"uniqueKey\" could not be initialized"]
            throw(NSError(domain: "init", code: 1, userInfo: userInfo))
        }
        
        guard let firstName = dictionary[Parse.Constant.JSONResponseKey.firstName] as? String else {
            let userInfo = [NSLocalizedDescriptionKey: "The property \"firstName\" could not be initialized"]
            throw(NSError(domain: "init", code: 1, userInfo: userInfo))
        }
        
        guard let lastName = dictionary[Parse.Constant.JSONResponseKey.lastName] as? String else {
            let userInfo = [NSLocalizedDescriptionKey: "The property \"lastName\" could not be initialized"]
            throw(NSError(domain: "init", code: 1, userInfo: userInfo))
        }
        
        guard let mapString = dictionary[Parse.Constant.JSONResponseKey.mapString] as? String else {
            let userInfo = [NSLocalizedDescriptionKey: "The property \"mapString\" could not be initialized"]
            throw(NSError(domain: "init", code: 1, userInfo: userInfo))
        }
        
        guard let mediaURL = dictionary[Parse.Constant.JSONResponseKey.mediaURL] as? String else {
            let userInfo = [NSLocalizedDescriptionKey: "The property \"mediaURL\" could not be initialized"]
            throw(NSError(domain: "init", code: 1, userInfo: userInfo))
        }
        
        guard let latitude = dictionary[Parse.Constant.JSONResponseKey.latitude] as? Double else {
            let userInfo = [NSLocalizedDescriptionKey: "The property \"latitude\" could not be initialized"]
            throw(NSError(domain: "init", code: 1, userInfo: userInfo))
        }
        
        guard let longitude = dictionary[Parse.Constant.JSONResponseKey.longitud] as? Double else {
            let userInfo = [NSLocalizedDescriptionKey: "The property \"longitude\" could not be initialized"]
            throw(NSError(domain: "init", code: 1, userInfo: userInfo))
        }
        
        // Initialize properties.
        self.objectID = objectID
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
