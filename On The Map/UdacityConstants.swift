//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/29/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import Foundation

// MARK: Constants

extension Udacity {
    
    struct Constant {
        
        struct URL {
            static let apiScheme = "https"
            static let apiHost = "www.udacity.com"
            static let apiPath = "/api"
        }
        
        struct Method {
            static let session = "/session"
            static let users = "/users/<user_id>"
        }
        
        struct HTTPHeaderField {
            static let contentType = "Content-Type"
            static let accept = "Accept"
            static let cookie = "X-XSRF-TOKEN"
        }
        
        struct HTTPHeaderFieldValue {
            static let appJSON = "application/json"
        }
        
        struct JSONResponseKey {
            static let account = "account"
            static let accountKey = "key"
            static let session = "session"
            static let sessionID = "id"
            static let user = "user"
            static let firstName = "first_name"
            static let lastName = "last_name"
            static let registered = "registered"
        }
        
        struct JSONBodyKey {
            static let udacity = "udacity"
            static let username = "username"
            static let password = "password"
            static let facebookMobile = "facebook_mobile"
            static let accessToken = "access_token"
        }
        
    }
    
}
