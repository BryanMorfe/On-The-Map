//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/28/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit

// MARK: Convenience Methods

extension Parse {
    
    func getStudentLocation(uniqueKey: String, withCompletionHandler handler: @escaping (Bool, Bool, String?) -> Void) {
        
        // Get the Data of ONE Student
        
        // Setup Parameters
        let parameters: [String: AnyObject] = [
            Parse.Constant.ParameterKey.whereKey: "{\"\(Parse.Constant.ParameterValue.uniqueKey)\":\"\(uniqueKey)\"}" as AnyObject
        ]
        
        // Start GET Request
        taskForGET(withMethod: Parse.Constant.Method.studentLocation, parameters: parameters) {
            (data, error) in
            
            // Check for errors
            guard error == nil else {
                handler(false, false, error!.localizedDescription)
                return
            }
            
            // Gather data
            guard let parsedData = data else {
                handler(false, false, "Returned data could not be accessed.")
                return
            }
            
            guard let results = parsedData[Parse.Constant.JSONResponseKey.results] as? [[String: AnyObject]]else {
                handler(false, false, "Results from the parsed data could not be accessed.")
                return
            }
            
            // Get student data
            if results.count > 0 {
                do {
                    StudentManager.current.currentStudent = try StudentInformation(with: results[0])
                    handler(true, true, nil)
                } catch {
                    print("Student not initialized.")
                    handler(false, false, "Student not initialized.")
                }
            
            } else {
                handler(true, false, "User has not dropped a pin.")
            }
            
        }
    }
    
    func getStudentsLocations(limit: Float = 100, skip: Float? = nil, order: String? = nil, withCompletionHandler handler: @escaping (Bool, String?) -> Void) {
        
        // Get a number of Students locations.
        
        // Setup Parameters
        var parameters: [String: AnyObject] = [
            Parse.Constant.ParameterKey.limit: limit as AnyObject,
        ]
        
        if let sk = skip {
            parameters[Parse.Constant.ParameterKey.skip] = sk as AnyObject
        }
        
        if let ord = order {
            parameters[Parse.Constant.ParameterKey.order] = ord as AnyObject
        }
        
        // Start GET Request
        taskForGET(withMethod: Parse.Constant.Method.studentLocation, parameters: parameters) {
            (data, error) in
            
            // Check for errors.
            guard error == nil else {
                handler(false, error!.localizedDescription)
                return
            }
            
            // Gather data
            guard let parsedData = data else {
                handler(false, "Returned data could not be accessed.")
                return
            }
            
            guard let results = parsedData[Parse.Constant.JSONResponseKey.results] as? [[String: AnyObject]] else {
                handler(false, "Results from the parsed data could not be accessed.")
                return
            }
            
            // Initialize studentsInformation Object
            StudentManager.current.students = []
            
            // Ititerate through all results and ignore students with 'nil' information.
            for result in results {
                var student: StudentInformation
                do {
                    student = try StudentInformation(with: result)
                    StudentManager.current.students.append(student)
                } catch {
                    print("Student popped.")
                }
                
            }
            
            handler(true, nil)
        }
    }
    
    func postStudentLocation(with uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, withCompletionHandler handler: @escaping (Bool, String?) -> Void) {
        
        // Posts a NEW location for a student
        
        // Setup JSON Body
        let jsonBody = "{\"\(Parse.Constant.JSONBodyKey.uniqueKey)\": \"\(uniqueKey)\", \"\(Parse.Constant.JSONBodyKey.firstName)\": \"\(firstName)\", \"\(Parse.Constant.JSONBodyKey.lastName)\": \"\(lastName)\", \"\(Parse.Constant.JSONBodyKey.mapString)\": \"\(mapString)\", \"\(Parse.Constant.JSONBodyKey.mediaURL)\": \"\(mediaURL)\", \"\(Parse.Constant.JSONBodyKey.latitude)\": \(latitude), \"\(Parse.Constant.JSONBodyKey.longitud)\": \(longitude)}"
        
        // Start POST Request
        taskForPOST(withMethod: Parse.Constant.Method.studentLocation, parameters: nil, jsonBody: jsonBody) {
            (data, error) in
            
            // Check for errors
            guard error == nil else {
                handler(false, error!.localizedDescription)
                return
            }
            
            // Gather data
            guard let parsedData = data else {
                handler(false, "Returned data could not be accessed.")
                return
            }
            
            guard let objectID = parsedData[Parse.Constant.JSONResponseKey.objectID] as? String else {
                handler(false, "Could not retrieve object id.")
                return
            }
            
            // Build dictionary from data to initialize the currentStudent property.
            // For clarifications of the purpose of "currentStudent", go to the 'ControllerCommon:configure' method.
            let userDictionary: [String: AnyObject] =
                [
                    Parse.Constant.JSONResponseKey.objectID: objectID as AnyObject,
                    Parse.Constant.JSONResponseKey.uniqueKey: uniqueKey as AnyObject,
                    Parse.Constant.JSONResponseKey.firstName: firstName as AnyObject,
                    Parse.Constant.JSONResponseKey.lastName: lastName as AnyObject,
                    Parse.Constant.JSONResponseKey.mapString: mapString as AnyObject,
                    Parse.Constant.JSONResponseKey.mediaURL: mediaURL as AnyObject,
                    Parse.Constant.JSONResponseKey.latitude: latitude as AnyObject,
                    Parse.Constant.JSONResponseKey.longitud: longitude as AnyObject
                ]
            
            do {
                StudentManager.current.currentStudent = try StudentInformation(with: userDictionary)
                handler(true, nil)
            } catch {
                handler(false, "Some properties could not be initialized.")
                return
            }
            
        }
        
    }
    
    func updateStudentLocation(with objectID: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, withCompletionHandler handler: @escaping (Bool, String?) -> Void) {
        
        // UPDATE the location of a student
        
        // Setup the method
        let method = ClientCommon.replace(key: "<object_id>", with: "\(objectID)", in: Parse.Constant.Method.putStudentLocation)!
        
        // Setup JSON Body
        let jsonBody = "{\"\(Parse.Constant.JSONBodyKey.mapString)\": \"\(mapString)\", \"\(Parse.Constant.JSONBodyKey.mediaURL)\": \"\(mediaURL)\", \"\(Parse.Constant.JSONBodyKey.latitude)\": \(latitude), \"\(Parse.Constant.JSONBodyKey.longitud)\": \(longitude)}"
        
        // Start PUT Request
        taskForPUT(withMethod: method, parameters: nil, jsonBody: jsonBody) { (data, error) in
            
            // Check for error
            guard error == nil else {
                handler(false, error!.localizedDescription)
                return
            }
            
            guard data != nil else {
                handler(false, "Could not retrieve the data.")
                return
            }
            
            // The only four properties that change will be these.
            // Safe to unwrap here
            StudentManager.current.currentStudent!.mapString = mapString
            StudentManager.current.currentStudent!.mediaURL = mediaURL
            StudentManager.current.currentStudent!.latitude = latitude
            StudentManager.current.currentStudent!.longitude = longitude
            
            handler(true, nil)
            
        }
    }
    
}
