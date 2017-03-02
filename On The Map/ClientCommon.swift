//
//  ClientCommon.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/29/17.
//  Copyright © 2017 Morfe. All rights reserved.
//
//  This class contains the code that is shared between
//  the API Clients.

import UIKit

class ClientCommon {
    
    // MARK: Properties
    
    class var session: URLSession {
        return URLSession.shared
    }
    
    // MARK: Methods
    
    class func covert(data: Data, withCompletionHandler handler: @escaping (AnyObject?, NSError?) -> Void) {
        
        // Converts data to json object
        
        var parsedData: AnyObject!
        
        do {
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data as JSON: \(data)"]
            handler(nil, NSError(domain: "convert", code: 1, userInfo: userInfo))
            return
        }
        
        handler(parsedData, nil)
        
    }
    
    class func checkErrors(in domain: String, data: Data?, response: URLResponse?, error: Error?, withCompletionHandler handler: (Data?, NSError?) -> Void) {
        
        // Checks for errors
        
        guard error == nil else {
            let userInfo = [NSLocalizedDescriptionKey: "An error has occured: \(error!.localizedDescription)"]
            handler(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
            return
        }
        
        guard data != nil else {
            let userInfo = [NSLocalizedDescriptionKey: "An error has occured: \(error!.localizedDescription)"]
            handler(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            var message: String = "An error code was returned."
            if let sc = statusCode {
                if sc == 403 && Udacity.shared.isLogginInWithFacebook {
                    message = "Your facebook account is not connected to any Udacity account."
                } else if sc == 403 {
                    message = "The username and/or password you enter do not match."
                }
            }
            let userInfo = [NSLocalizedDescriptionKey: message]
            handler(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
            return
        }
        
        handler(data, nil)
        
    }
    
    class func url(for client: APIClient, fromParameters parameters: [String: AnyObject]?, withPathExtension path: String? = nil) -> URL? {
        
        // Builds a URL
        
        var components = URLComponents()
        
        if let _ = client as? Parse {
            components.scheme = Parse.Constant.URL.apiScheme
            components.host = Parse.Constant.URL.apiHost
            components.path = Parse.Constant.URL.apiPath + (path ?? "")
        } else if let _ = client as? Udacity {
            components.scheme = Udacity.Constant.URL.apiScheme
            components.host = Udacity.Constant.URL.apiHost
            components.path = Udacity.Constant.URL.apiPath + (path ?? "")
        }
        
        if let param = parameters {
        
            components.queryItems = [URLQueryItem]()
        
            for (key, value) in param {
                let query = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(query)
            }
            
        }
        
        return components.url
        
    }
    
    class func replace(key: String, with value: String, in method: String) -> String? {
        
        // Replaces a key in a method with a given value
        
        if method.range(of: key) != nil {
            return method.replacingOccurrences(of: key, with: value)
        } else {
            return nil
        }
    }
    
}
