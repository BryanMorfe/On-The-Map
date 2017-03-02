//
//  ControllerCommon.swift
//  On The Map
//
//  Created by Bryan Morfe on 2/9/17.
//  Copyright © 2017 Morfe. All rights reserved.
//
//  Convenience Object that contains code to be shared
//  among view controller.

import UIKit
import FBSDKLoginKit

class ControllerCommon {
    
    // MARK: Properties
    
    var userDroppedPin: Bool = false
    
    // Loading view components
    private var dimmerView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    static let shared = ControllerCommon()
    
    // MARK: Methods
    
    func configure() {
        
        // Check whether user has already dropped a pin.
        
        // This will check if the user in is the parse database, and will update the 'currentStudent' object so that it can be modified.
        Parse.shared.getStudentLocation(uniqueKey: Udacity.shared.accountKey!) {
            (_, found, _) in
            self.userDroppedPin = found
        }
    }
    
    func configureLoadingView(for view: UIView) {
        
        // Configures the 'loading view' for a view in a controller.
        
        dimmerView = UIView()
        dimmerView.backgroundColor = .black
        dimmerView.layer.opacity = 0
        dimmerView.frame = view.frame
        view.addSubview(dimmerView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.frame.origin.x = (view.frame.width / 2) - activityIndicator.frame.size.width / 2
        activityIndicator.frame.origin.y = (view.frame.height / 2) - activityIndicator.frame.size.height / 2
        view.addSubview(activityIndicator)
        
        dimmerView.isHidden = true
        activityIndicator.isHidden = true
    }
    
    func setLoadingView(to state: UserInterface.UIState) {
        switch state {
        case .enabled:
            dimmerView.isHidden = false
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {
                self.dimmerView.layer.opacity = 0.5
            })
        case .disabled:
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { _ in
                self.dimmerView.isHidden = true
            })
            UIView.animate(withDuration: 0.2, animations: {
                self.dimmerView.layer.opacity = 0
            })
        }
    }
    
    func logout(target: UIViewController, withErrorHandler handler: @escaping (Void) -> Void) {
        
        // Clears cookies for udacity session and logs out facebook if necessary.
        
        configureLoadingView(for: target.view)
        setLoadingView(to: .enabled)
        
        let udacityClient = Udacity.shared
        
        udacityClient.clearCookie { (success, errorString) in
            if success {
                DispatchQueue.main.async {
                    if udacityClient.isFacebookLogged {
                        let facebookManager = FBSDKLoginManager()
                        facebookManager.logOut()
                    }
                    target.dismiss(animated: true, completion: nil)
                }
            } else {
                print(errorString!)
                DispatchQueue.main.async {
                    self.setLoadingView(to: .disabled)
                    ControllerCommon.presentAlertController(forTarget: target, withTitle: "Log out error", message: "There was an error while logging out.")
                    handler()
                }
            }
        }
        
    }
    
    func dropPin(forTarget target: UIViewController, withSegueIdentifier identifier: String) {
        
        // This will check if user dropped a pin, if they did ask them if they'd like to overwrite
    
        if userDroppedPin {
            let message = "You have already dropped a pin for your location. Would you like to overwrite it?"
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .cancel, handler: { (_) in
                target.performSegue(withIdentifier: identifier, sender: self)
            })
            ControllerCommon.presentAlertController(forTarget: target, withTitle: "Pin Already Dropped", message: message, actionTitle: "Cancel", extraActions: [overwriteAction])
            
        } else {
            target.performSegue(withIdentifier: identifier, sender: self)
        }
    }
    
    class func presentAlertController(forTarget target: UIViewController, withTitle title: String, message: String, dismissTarget: Bool = false, actionTitle: String? = nil, extraActions: [UIAlertAction]? = nil) {
        
        // Presents a customized alert controller for in a target view controller.
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // actions
        let action = UIAlertAction(title: actionTitle ?? "Okay", style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
            if dismissTarget {
                target.dismiss(animated: true, completion: nil)
            }
        }
        
        alertController.addAction(action)
        
        if let actions = extraActions {
            for action in actions {
                alertController.addAction(action)
            }
        }
        
        target.present(alertController, animated: true, completion: nil)
    }
    
}
