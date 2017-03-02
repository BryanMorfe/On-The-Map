//
//  StudentsTableViewController.swift
//  On The Map
//
//  Created by Bryan Morfe on 2/9/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var dropPinButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI(to: .enabled)
    }
    
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
        ControllerCommon.shared.dropPin(forTarget: self, withSegueIdentifier: "TableDropPinSegue")
    }
    
    @IBAction func reload() {
        
        // Load more current students.
        
        setUI(to: .disabled)
        let parseClient = Parse.shared
        
        parseClient.getStudentsLocations(order: "-updatedAt") {
            (success, errorString) in
            DispatchQueue.main.async {
                self.setUI(to: .enabled)
            }
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                DispatchQueue.main.async {
                    ControllerCommon.presentAlertController(forTarget: self, withTitle: "Failed to load", message: "Could not load students information.")
                }
            }
        }
    }

}

// MARK: Convenience Methods

extension StudentsTableViewController {
    
    func setUI(to state: UserInterface.UIState) {
        
        // Sets the UI to 'enabled' or 'disabled' mode
        
        switch state {
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

// MARK: Table View Data Source

extension StudentsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentManager.current.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Builds Cells with Students' information
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as UITableViewCell
        
        
        let firstName = StudentManager.current.students[indexPath.row].firstName
        let lastName = StudentManager.current.students[indexPath.row].lastName
        cell.textLabel?.text = "\(firstName) \(lastName)"
        
        return cell
    }
    
}

// MARK: Table View Delegate

extension StudentsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let urlString = StudentManager.current.students[indexPath.row].mediaURL
        
        // Protection against invalid URLs
        if let url = URL(string: urlString) {
            let app = UIApplication.shared
            app.open(url, options: [:], completionHandler: {
                (success) in
                if !success {
                    DispatchQueue.main.async {
                        ControllerCommon.presentAlertController(forTarget: self, withTitle: "Invalid URL", message: "The URL \"\(urlString)\" could not be opened. Try a different one.")
                    }
                }
            })
        } else {
            ControllerCommon.presentAlertController(forTarget: self, withTitle: "Invalid URL", message: "The URL \"\(urlString)\" is Invalid. Try a different one.")
        }
        
    }
    
}
