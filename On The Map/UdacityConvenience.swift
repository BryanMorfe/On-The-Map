//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/28/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit

// MARK: Convenience Methods

extension Udacity {
    
    func authenticate(with username: String, password: String, withCompletionHandler handler: @escaping (Bool, String?) -> Void) {
        
        // Authenticate with regular udacity credentials.
        
        let jsonBody = "{\"\(Udacity.Constant.JSONBodyKey.udacity)\": {\"\(Udacity.Constant.JSONBodyKey.username)\": \"\(username)\", \"\(Udacity.Constant.JSONBodyKey.password)\": \"\(password)\"}}"
      
        // Start POST request
        taskForPOST(withMethod: Udacity.Constant.Method.session, parameters: nil, jsonBody: jsonBody) {
            (data, error) in
            
            // Check for errors
            guard error == nil else {
                handler(false, error!.localizedDescription)
                return
            }
            
            guard let parsedData = data else {
                handler(false, "An error has occured while parsing the data.")
                return
            }
            
            guard let dataDictionary = parsedData as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the parsed data.")
                return
            }
            
            // Parsing data while checking for errors
            guard let session = dataDictionary[Udacity.Constant.JSONResponseKey.session] as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the session data.")
                return
            }
            
            guard let account = dataDictionary[Udacity.Constant.JSONResponseKey.account] as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the account data.")
                return
            }
            
            // Make sure we have the necessary info and assign it to the class' properties
            if let id = session[Udacity.Constant.JSONResponseKey.sessionID] as? String, let accountID = account[Udacity.Constant.JSONResponseKey.accountKey] as? String {
                self.sessionID = id
                self.accountKey = accountID
                handler(true, nil)
                return
            }
            
            handler(false, "Could not gather session ID and/or Account Key.")
            
        }
        
    }
    
    func authenticateWithFacebook(accessToken: String, withCompletionHandler handler: @escaping (Bool, String?) -> Void) {
        
        // Authenticate with facebook.
        
        let jsonBody = "{\"\(Udacity.Constant.JSONBodyKey.facebookMobile)\": {\"\(Udacity.Constant.JSONBodyKey.accessToken)\": \"\(accessToken)\"}}"
        
        // Start POST request
        taskForPOST(withMethod: Udacity.Constant.Method.session, parameters: nil, jsonBody: jsonBody) {
            (data, error) in
            
            // Check for errors
            guard error == nil else {
                handler(false, error!.localizedDescription)
                return
            }
            
            guard let parsedData = data else {
                handler(false, "An error has occured while parsing the data.")
                return
            }
            
            guard let dataDictionary = parsedData as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the parsed data.")
                return
            }
            
            // Parsing data while checking for errors
            guard let session = dataDictionary[Udacity.Constant.JSONResponseKey.session] as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the session data.")
                return
            }
            
            guard let account = dataDictionary[Udacity.Constant.JSONResponseKey.account] as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the account data.")
                return
            }
            
            // Make sure we have the necessary info and assign it to the class' properties
            
            if let id = session[Udacity.Constant.JSONResponseKey.sessionID] as? String, let accountID = account[Udacity.Constant.JSONResponseKey.accountKey] as? String {
                self.sessionID = id
                self.accountKey = accountID
                self.isFacebookLogged = true
                handler(true, nil)
                return
            }
            
            handler(false, "Could not gather session ID and/or Account Key.")
        }
        
    }
    
    func clearCookie(withCompletionHandler handler: @escaping (Bool, String?) -> Void) {
        
        // Delete session cookies, AKA Log out.
        
        // Start DELETE request
        taskForDELETE(withMethod: Udacity.Constant.Method.session, parameters: nil) {
            (data, error) in
            
            // Checking for errors
            guard error == nil else {
                handler(false, "An error has occured while making this request. \(error!.localizedDescription)")
                return
            }
            
            // Gather data
            guard let parsedData = data else {
                handler(false, "An error has occured while parsing the data.")
                return
            }
            
            guard let dataDictionary = parsedData as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the parsed data.")
                return
            }
            
            guard let session = dataDictionary[Udacity.Constant.JSONResponseKey.session] as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the session data.")
                return
            }
            
            // Clear properties
            if let _ = session[Udacity.Constant.JSONResponseKey.sessionID] as? String {
                self.accountKey = nil
                self.sessionID = nil
                self.udacian = nil
                handler(true, nil)
                return
            }
            
            handler(false, "Could not parse session ID.")
            
        }
    }
    
    func getUserInfo(withCompletionHandler handler: @escaping (Bool, String?) -> Void) {
        
        // Get user data (First and Last name)
        
        // Get account ID
        guard let accountID = self.accountKey else {
            handler(false, "Cannot find user ID. Try signing in again.")
            return
        }
        
        // Setup method
        let method = ClientCommon.replace(key: "<user_id>", with: accountID, in: Udacity.Constant.Method.users)!
        
        // Start GET request
        taskForGET(withMethod: method, parameters: nil) {
            (data, error) in
            
            // Check for errors
            
            guard error == nil else {
                handler(false, "An error has occured while making this request. \(error!.localizedDescription)")
                return
            }
            
            // Gather Data
            
            guard let parsedData = data else {
                handler(false, "An error has occured while parsing the data.")
                return
            }
            
            guard let dataDictionary = parsedData as? [String: AnyObject] else {
                handler(false, "An error has occured while accessing the parsed data.")
                return
            }
            
            // Create the Udacian Object and Handle and error while creating it
            
            do {
                self.udacian = try Udacian(with: dataDictionary)
                handler(true, nil)
            } catch {
                handler(false, "Udacian object could not be initialized.")
                return
            }
        }
    }
    
}
