//
//  ParseConstants.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/29/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import Foundation

// MARK: Constants

extension Parse {
    
    struct Constant {
        
        struct URL {
            static let apiScheme = "https"
            static let apiHost = "parse.udacity.com"
            static let apiPath = "/parse"
        }
        
        struct Method {
            static let studentLocation = "/classes/StudentLocation"
            static let putStudentLocation = "/classes/StudentLocation/<object_id>"
        }
        
        struct ParameterKey {
            static let apiKey = "api_key"
            static let appID = "app_id"
            static let limit = "limit"
            static let skip = "skip"
            static let order = "order"
            static let whereKey = "where"
        }
        
        struct ParameterValue {
            static let uniqueKey = "uniqueKey"
        }
        
        struct HTTPHeaderField {
            static let apiKey = "X-Parse-REST-API-Key"
            static let appID = "X-Parse-Application-ID"
            static let contentType = "Content-Type"
            static let accept = "Accept"
        }
        
        struct HTTPHeaderFieldValue {
            static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            static let appJSON = "application/json"
        }
        
        struct JSONResponseKey {
            static let results = "results"
            static let objectID = "objectId"
            static let uniqueKey = "uniqueKey"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let mapString = "mapString"
            static let mediaURL = "mediaURL"
            static let latitude = "latitude"
            static let longitud = "longitude"
            static let createdAt = "createAt"
            static let updateAt = "updatedAt"
            static let acl = "ACL"
        }
        
        struct JSONBodyKey {
            static let objectID = "objectId"
            static let uniqueKey = "uniqueKey"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let mapString = "mapString"
            static let mediaURL = "mediaURL"
            static let latitude = "latitude"
            static let longitud = "longitude"
            static let createdAt = "createAt"
            static let updateAt = "updatedAt"
            static let acl = "ACL"
        }
        
    }
    
}
