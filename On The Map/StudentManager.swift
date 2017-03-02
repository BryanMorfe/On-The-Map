//
//  StudentManager.swift
//  On The Map
//
//  Created by Bryan Morfe on 2/13/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import Foundation

class StudentManager {
    
    // MARK: Properties
    
    var students: [StudentInformation] = []
    var currentStudent: StudentInformation?
    var udacian: Udacian!
    
    static let current = StudentManager()
    
}
