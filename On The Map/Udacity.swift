//
//  Udacity.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/28/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit

class Udacity: APIClient {
    
    // MARK: Properties
    
    var sessionID: String?
    var accountKey: String?
    var udacian: Udacian?
    
    var isFacebookLogged: Bool = false
    var isLogginInWithFacebook: Bool = false
    
    static let shared = Udacity()
    
    // MARK: Methods
    
    func taskForGET(withMethod method: String, parameters: [String: AnyObject]?, withCompletionHandler handler: @escaping (AnyObject?, NSError?) -> Void) {
        
        // Setup URL
        let url = ClientCommon.url(for: self, fromParameters: parameters, withPathExtension: method)
        
        // Setup request
        let request = URLRequest(url: url!)
        
        // Setup task
        let task = ClientCommon.session.dataTask(with: request) {
            (data, response, error) in
            
            ClientCommon.checkErrors(in: "taskForGET", data: data, response: response, error: error) {
                (data, error) in
                if let error = error {
                    handler(nil, error)
                } else {
                    let range = Range(uncheckedBounds: (5, data!.count))
                    let newData = data!.subdata(in: range)
                    ClientCommon.covert(data: newData, withCompletionHandler: handler)
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
        request.addValue(Udacity.Constant.HTTPHeaderFieldValue.appJSON, forHTTPHeaderField: Udacity.Constant.HTTPHeaderField.accept)
        request.addValue(Udacity.Constant.HTTPHeaderFieldValue.appJSON, forHTTPHeaderField: Udacity.Constant.HTTPHeaderField.contentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Setup task
        let task = ClientCommon.session.dataTask(with: request as URLRequest) {
            (data, response, error) in
                        
            ClientCommon.checkErrors(in: "taskForPOST", data: data, response: response, error: error) {
                (data, internalError) in
                if let error = internalError {
                    handler(nil, error)
                } else {
                    let range = Range(uncheckedBounds: (5, data!.count))
                    let newData = data!.subdata(in: range)
                    ClientCommon.covert(data: newData, withCompletionHandler: handler)
                }
            }
            
        }
        
        // Start task
        task.resume()
        
    }
    
    func taskForDELETE(withMethod method: String, parameters: [String: AnyObject]?, withCompletionHandler handler: @escaping (AnyObject?, NSError?) -> Void) {
        
        // Setup URL
        let url = ClientCommon.url(for: self, fromParameters: parameters, withPathExtension: method)
        
        // Setup request
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: Udacity.Constant.HTTPHeaderField.cookie)
        }
        
        // Setup task
        let task = ClientCommon.session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            ClientCommon.checkErrors(in: "taskForDELETE", data: data, response: response, error: error) {
                (data, error) in
                if let error = error {
                    handler(nil, error)
                } else {
                    let range = Range(uncheckedBounds: (5, data!.count))
                    let newData = data!.subdata(in: range)
                    ClientCommon.covert(data: newData, withCompletionHandler: handler)
                }
            }
            
        }
        
        // Start task
        task.resume()
        
    }
    
}
