//
//  Parse.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/28/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit

class Parse: APIClient {
    
    // MARK: Properties
    
    var tokenID: String?
    var userID: Int?
    
    static let shared = Parse()
    
    
    // MARK: Methods
    
    func taskForGET(withMethod method: String, parameters: [String: AnyObject], withCompletionHandler handler: @escaping (AnyObject?, NSError?) -> Void) {
        
        // Setup URL
        let url = ClientCommon.url(for: self, fromParameters: parameters, withPathExtension: method)
        
        // Setup request
        let request = NSMutableURLRequest(url: url!)
        request.addValue(Parse.Constant.HTTPHeaderFieldValue.apiKey, forHTTPHeaderField: Parse.Constant.HTTPHeaderField.apiKey)
        request.addValue(Parse.Constant.HTTPHeaderFieldValue.appID, forHTTPHeaderField: Parse.Constant.HTTPHeaderField.appID)
        
        // Setup task
        let task = ClientCommon.session.dataTask(with: request as URLRequest) {
            (data, response, error) in
                        
            ClientCommon.checkErrors(in: "taskForGET", data: data, response: response, error: error) {
                (data, error) in
                if let error = error {
                    handler(nil, error)
                } else {
                    ClientCommon.covert(data: data!, withCompletionHandler: handler)
                }
            }
            
        }
        
        // Start task
        task.resume()
        
    }
    
    func taskForPOST(withMethod method: String, parameters: [String: AnyObject]?, jsonBody: String, withCompletionHandler handler: @escaping (AnyObject?, NSError?) -> Void) {
        
        // Setup URL
        let url = ClientCommon.url(for: self, fromParameters: parameters, withPathExtension: method)
        
        // Setup request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(Parse.Constant.HTTPHeaderFieldValue.apiKey, forHTTPHeaderField: Parse.Constant.HTTPHeaderField.apiKey)
        request.addValue(Parse.Constant.HTTPHeaderFieldValue.appID, forHTTPHeaderField: Parse.Constant.HTTPHeaderField.appID)
        request.addValue(Parse.Constant.HTTPHeaderFieldValue.appJSON, forHTTPHeaderField: Parse.Constant.HTTPHeaderField.contentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Setup task
        let task = ClientCommon.session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            ClientCommon.checkErrors(in: "taskForPOST", data: data, response: response, error: error) {
                (data, error) in
                if let error = error {
                    handler(nil, error)
                } else {
                    ClientCommon.covert(data: data!, withCompletionHandler: handler)
                }
            }
            
        }
        
        // Start task
        task.resume()
        
    }
    
    func taskForPUT(withMethod method: String, parameters: [String: AnyObject]?, jsonBody: String, withCompletionHandler handler: @escaping (AnyObject?, NSError?) -> Void) {
        
        // Setup URL
        let url = ClientCommon.url(for: self, fromParameters: parameters, withPathExtension: method)
        
        // Setup request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(Parse.Constant.HTTPHeaderFieldValue.apiKey, forHTTPHeaderField: Parse.Constant.HTTPHeaderField.apiKey)
        request.addValue(Parse.Constant.HTTPHeaderFieldValue.appID, forHTTPHeaderField: Parse.Constant.HTTPHeaderField.appID)
        request.addValue(Parse.Constant.HTTPHeaderFieldValue.appJSON, forHTTPHeaderField: Parse.Constant.HTTPHeaderField.contentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Setup task
        let task = ClientCommon.session.dataTask(with: request as URLRequest) {
            (data, response, error) in
                        
            ClientCommon.checkErrors(in: "taskForPUT", data: data, response: response, error: error) {
                (data, error) in
                if let error = error {
                    handler(nil, error)
                } else {
                    ClientCommon.covert(data: data!, withCompletionHandler: handler)
                }
            }
            
        }
        
        // Start task
        task.resume()
        
    }
    
}
