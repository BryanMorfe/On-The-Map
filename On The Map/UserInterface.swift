//
//  UserInterface.swift
//  On The Map
//
//  Created by Bryan Morfe on 2/9/17.
//  Copyright © 2017 Morfe. All rights reserved.
//
//  Here are some convenience code that is to be shared
//  among views in different controllers but are not part of the clients.
//

import UIKit

struct UserInterface {
    
    // MARK: Enumerations
    
    enum UIState {
        case enabled, disabled
    }
    
    // MARK: Constants
    
    struct Constant {
        
        struct Color {
            // background
            static let backgroundTop = UIColor(red: 1.0, green: 0.627, blue: 0, alpha: 1).cgColor
            static let backgroundBottom = UIColor(red: 1.0, green: 0.529, blue: 0, alpha: 1).cgColor
            
            // facebook
            static let facebookBlue = UIColor(red: 0.231, green: 0.349, blue: 0.596, alpha: 1)
            static let facebookBlueDarker = UIColor(red: 0.192, green: 0.286, blue: 0.490, alpha: 1)
            
            // login orange
            static let loginOrange = UIColor(red: 1.0, green: 0.353, blue: 0, alpha: 1)
            static let loginOrangeDarker = UIColor(red: 1.0, green: 0.314, blue: 0, alpha: 1)
            
            // lazy white = white with alpha of 0.7
            static let lazyWhite = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
            
            static let lightGrey = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            static let darkerGrey = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
            
            static let linkBlue = UIColor(red: 0.145, green: 0.349, blue: 0.580, alpha: 1.0)
        }
        
    }
}
