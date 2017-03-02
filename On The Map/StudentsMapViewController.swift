//
//  StudentsMapViewController.swift
//  On The Map
//
//  Created by Bryan Morfe on 2/6/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var dropPinButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    var studentMap: MKMapView!
    var annotations: [MKPointAnnotation] = []
    
    // Restore supported orientatioins.
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.loadMapAnnotations()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
    }
    
    func loadMapAnnotations() {
        
        // Loads last 100 students and adds them to map annotations.
        
        setUI(to: .disabled)
        let parseClient = Parse.shared
        
        parseClient.getStudentsLocations(order: "-updatedAt") {
            (success, errorString) in
            
            DispatchQueue.main.async {
                self.setUI(to: .enabled)
            }
            
            if success {
                for student in StudentManager.current.students {
                    
                    let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
                    let title = "\(student.firstName) \(student.lastName)"
                    let urlString = student.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = title
                    annotation.subtitle = urlString
                    
                    self.annotations.append(annotation)
                }
            
                DispatchQueue.main.async {
                    self.studentMap.addAnnotations(self.annotations)
                }
                
            } else {
                DispatchQueue.main.async {
                    ControllerCommon.presentAlertController(forTarget: self, withTitle: "Failed to load", message: "Could not load students' information.", dismissTarget: true)
                }
                print(errorString!)
            }
            
        }
    }
    
    // MARK: Actions
    
    @IBAction func logout() {
        
        // Logs out using the 'logout' method of the ControllerCommon object
        // and handles any errors
        
        setUI(to: .disabled)
        ControllerCommon.shared.logout(target: self) {
            self.setUI(to: .enabled)
            ControllerCommon.presentAlertController(forTarget: self, withTitle: "Log out Error", message: "Could not log out. Try again.")
        }
    }
    
    @IBAction func dropPin() {
        // See 'dropPin' method from 'ControllerCommon' Object
        ControllerCommon.shared.dropPin(forTarget: self, withSegueIdentifier: "MapDropPinSegue")
    }
    
    @IBAction func reload() {
        
        // Removes current annotations and reloads more recent ones.
        
        studentMap.removeAnnotations(annotations)
        loadMapAnnotations()
        
    }

}

// MARK: Convenience Methods

extension StudentsMapViewController {
    
    func updateMapFrame() {
        studentMap.frame = view.frame
    }
    
    func configureMap() {
        
        // Creates and Configures the map.
        studentMap = MKMapView()
        updateMapFrame()
        studentMap.delegate = self
        view.addSubview(studentMap)
    }

    func setUI(to state: UserInterface.UIState) {
        
        // Sets the UI to 'enabled' or 'disabled' mode
        
        switch(state) {
        case .enabled:
            logoutButton.isEnabled = true
            dropPinButton.isEnabled = true
            reloadButton.isEnabled = true
        case .disabled:
            logoutButton.isEnabled = false
            dropPinButton.isEnabled = false
            reloadButton.isEnabled = false
        }
    }
    
}

// MARK: MKMapView Delegate

extension StudentsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Builds the Annotation views.
        
        let reuseIdentifier = "StudentPin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // Handles taps on annotaions.
        
        if control == view.rightCalloutAccessoryView {
            
            // Protection against invalid URLs.
            if let urlString = view.annotation?.subtitle {
                let app = UIApplication.shared
                if let url = URL(string: urlString!) {
                    app.open(url, options: [:], completionHandler: {
                        (success) in
                        if !success {
                            DispatchQueue.main.async {
                                ControllerCommon.presentAlertController(forTarget: self, withTitle: "Invalid URL", message: "The URL \"\(urlString!)\" could not be opened. Try a different one.")
                            }
                        }
                    })
                } else {
                    ControllerCommon.presentAlertController(forTarget: self, withTitle: "Invalid URL", message: "The URL \"\(urlString!)\" is Invalid. Try a different one.")
                }
            } else {
                ControllerCommon.presentAlertController(forTarget: self, withTitle: "No URLS", message: "There is not URL available to open.")
            }
            
        }
    }
    
}

// MARK: Subscriptions

extension StudentsMapViewController {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapFrame), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
}
