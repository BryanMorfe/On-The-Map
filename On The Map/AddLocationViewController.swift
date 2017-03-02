//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Bryan Morfe on 2/9/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet var whereAreYouLabel: [UILabel]!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var geocoderIndicator: UIActivityIndicatorView!
    
    var locationMap: MKMapView!
    
    var currentState: UIState!
    
    // MARK: MEthods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rebuildMap()
        setUI(to: .gettingLocation)
        configure(textField: locationField)
        configure(textField: urlTextField)
        ControllerCommon.shared.configureLoadingView(for: view)
        
        subscribeToNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func reset() {
        
        let _ = textFieldShouldReturn(locationField)
        let _ = textFieldShouldReturn(urlTextField)
        setUI(to: .gettingLocation)
    }

    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func geocodeSubmit(_ sender: UIButton) {
        if sender.tag == 0 {
            
            geocoderIndicator.isHidden = false
            geocoderIndicator.startAnimating()
            
            guard let mapString = locationField.text, !mapString.isEmpty else {
                ControllerCommon.presentAlertController(forTarget: self, withTitle: "Empty Location", message: "You must enter a location.")
                return
            }
            
            if locationField.isFirstResponder {
                locationField.resignFirstResponder()
            }
            
            // Geocode location
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationField.text!, completionHandler: {
                (placemarks, error) in
                
                DispatchQueue.main.async {
                    self.geocoderIndicator.stopAnimating()
                    self.geocoderIndicator.isHidden = true
                }
                
                guard error == nil else {
                    DispatchQueue.main.async {
                        let message = "A location could not be retrieved from \"\(mapString)\""
                        ControllerCommon.presentAlertController(forTarget: self, withTitle: "Location Error", message: message)
                    }
                    return
                }
                
                guard let location = placemarks?[0].location else {
                    print("No location could be retrieved for the provided placemarks.")
                    return
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                self.locationMap.addAnnotation(annotation)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                let region = MKCoordinateRegionMake(annotation.coordinate, span)
                
                DispatchQueue.main.async {
                    self.setUI(to: .submitting)
                    self.locationMap.setRegion(region, animated: true)
                }
            })
            
        } else {
            
            guard let mediaURL = urlTextField.text, !mediaURL.isEmpty else {
                ControllerCommon.presentAlertController(forTarget: self, withTitle: "Missing URL", message: "The URL is obligatory to submit location.")
                return
            }
            
            guard let mapString = locationField.text, !mapString.isEmpty else {
                ControllerCommon.presentAlertController(forTarget: self, withTitle: "Empty Location", message: "You must enter a location.")
                return
            }
            
            setUI(to: .submitted)
            
            // Check whether should update location or add a new one.
            if ControllerCommon.shared.userDroppedPin {
                
                /* Update current location */
                let parseClient = Parse.shared
                
                // It's safe to unwrap here because the only way that "userDroppedPin" is set to true
                // is if "currentStudent" is not nil.
                let objectID = StudentManager.current.currentStudent!.objectID
                let coordinate = locationMap.region.center
                
                parseClient.updateStudentLocation(with: objectID, mapString: mapString, mediaURL: mediaURL, latitude: coordinate.latitude, longitude: coordinate.longitude, withCompletionHandler: {
                    (success, errorString) in
                    if success {
                        // We have successfully updated the location.
                        DispatchQueue.main.async {
                            self.setUI(to: .submitting)
                            ControllerCommon.presentAlertController(forTarget: self, withTitle: "Updated", message: "Location successfully updated. It may take a few minutes for the changes to be reflected.", dismissTarget: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.setUI(to: .submitting)
                            ControllerCommon.presentAlertController(forTarget: self, withTitle: "Error while submitting", message: "An error occured while submitting the data: \(errorString!)", dismissTarget: true)
                        }
                    }
                })
                
            } else {
                let udacityClient = Udacity.shared
                
                // First we get the user's first name and last name.
                udacityClient.getUserInfo { (success, errorString) in
                    if success {
                        
                        /* Add new location */
                        let parseClient = Parse.shared
                        
                        guard let uniqueKey = udacityClient.accountKey else {
                            self.setUI(to: .submitting)
                            ControllerCommon.presentAlertController(forTarget: self, withTitle: "Account Key Error", message: "Could not retrieve account key.", dismissTarget: true)
                            return
                        }
                        
                        let coordinate = self.locationMap.region.center
                        
                        // Starting parse client request.
                        parseClient.postStudentLocation(with: uniqueKey, firstName: udacityClient.udacian!.firstName, lastName: udacityClient.udacian!.lastName, mapString: mapString, mediaURL: mediaURL, latitude: coordinate.latitude, longitude: coordinate.longitude, withCompletionHandler: { (success, errorString) in
                            if success {
                                DispatchQueue.main.async {
                                    self.setUI(to: .submitting)
                                    ControllerCommon.presentAlertController(forTarget: self, withTitle: "Submitted", message: "Location successfully submitted. It may take a few minutes for your location to be reflected.", dismissTarget: true)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.setUI(to: .submitting)
                                    ControllerCommon.presentAlertController(forTarget: self, withTitle: "Error while submitting", message: "An error occured while submitting the data: \(errorString!)", dismissTarget: true)
                                }
                            }
                        })
                        
                    } else {
                        self.setUI(to: .submitting)
                        ControllerCommon.presentAlertController(forTarget: self, withTitle: "Account Error", message: "Error retrieving account basic information.", dismissTarget: true)
                        print(errorString!)
                    }
                }
                
                
                
                
            }
        }
    }
}

// MARK: Convenience Methods

extension AddLocationViewController {
    
    enum UIState {
        case gettingLocation, submitting, submitted
    }
    
    func setUI(to state: UIState) {
        
        currentState = state
        
        switch state {
        case .gettingLocation:
            
            // Buttons.
            resetButton.isEnabled = false
            resetButton.setTitleColor(UserInterface.Constant.Color.facebookBlue, for: .normal)
            resetButton.setTitleColor(.lightGray, for: .disabled)
            
            cancelButton.setTitleColor(UserInterface.Constant.Color.facebookBlue, for: .normal)
            
            actionButton.tag = 0
            actionButton.setTitle("Find on Map", for: .normal)
            
            // Map
            locationMap.removeFromSuperview()
            rebuildMap()
            
            // Views
            topView.backgroundColor = UserInterface.Constant.Color.lightGrey
            
            locationView.isHidden = false
            
            bottomView.backgroundColor = UserInterface.Constant.Color.lightGrey
            bottomView.alpha = 1
            
            // Fields
            urlTextField.isHidden = true
            
            geocoderIndicator.isHidden = true
            geocoderIndicator.stopAnimating()
            
        case .submitting:
            
            // Buttons
            resetButton.isEnabled = true
            resetButton.setTitleColor(.white, for: .normal)
            
            actionButton.tag = 1
            actionButton.setTitle("Submit", for: .normal)
            actionButton.isEnabled = true
            
            cancelButton.isEnabled = true
            cancelButton.setTitleColor(.white, for: .normal)
            
            // Map
            view.addSubview(locationMap)
            view.sendSubview(toBack: locationMap)
            
            // Views
            topView.backgroundColor = UserInterface.Constant.Color.facebookBlue
            
            locationView.isHidden = true
            
            bottomView.alpha = 0.25
            
            // Fields
            urlTextField.isHidden = false
            
            // Disable the loading view.
            ControllerCommon.shared.setLoadingView(to: .disabled)
            
        case .submitted:
            
            // Disable UI
            resetButton.isEnabled = false
            cancelButton.isEnabled = false
            actionButton.isEnabled = false
            
            // Enable and show loading view
            ControllerCommon.shared.setLoadingView(to: .enabled)
            
        }
        
    }
    
    func configure(textField: UITextField) {
        textField.delegate = self
        
        let placeholderAttributes = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UserInterface.Constant.Color.darkerGrey])
        
        textField.attributedPlaceholder = placeholderAttributes
        
    }
    
    func updateMapFrame() {
        locationMap!.frame = CGRect(x: 0, y: view.frame.size.height * 0.35, width: view.frame.size.width, height: view.frame.size.height * 0.65)
    }
    
    func rebuildMap() {
        locationMap = MKMapView()
        updateMapFrame()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrame.cgRectValue.height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if currentState == .gettingLocation {
            
            // Only shift the view if it's getting the user's location.
            if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
                // Only shifts half the keyboard height when in landscape
                view.frame.origin.y = -getKeyboardHeight(notification: notification) / 2
            } else {
                view.frame.origin.y = -getKeyboardHeight(notification: notification)
            }
        }
    }
    
    func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
}

// MARK: TextField Delegate Methods

extension AddLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: NotificationCenter Subscriptions

extension AddLocationViewController {
    
    func subscribeToNotifications() {
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        // Device Orientation
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapFrame), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func unsubscribeToNotifications() {
        
        // Keyboard notifications
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
        // Device Orientation
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
}
