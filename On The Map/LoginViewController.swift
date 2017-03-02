//
//  ViewController.swift
//  On The Map
//
//  Created by Bryan Morfe on 1/28/17.
//  Copyright © 2017 Morfe. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var facebookButton: BorderedButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signUpText: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Signing in portrait mode is more adequate, I think.
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // Just in case it is not in portrait, set it to portrait.
        if UIDevice.current.orientation != .portrait {
            UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    func login() {
        
        // Logs in with regular udacity credentials
        
        // Disable UI and start activity indicator.
        setUI(to: .disabled)
        activityIndicator.startAnimating()
        
        // Make sure the fields have some information in them.
        guard let username = usernameField.text, !username.isEmpty, let password = passwordField.text, !password.isEmpty else {
            ControllerCommon.presentAlertController(forTarget: self, withTitle: "Empty Field(s)", message: "Both fields are required to sign in.")
            self.setUI(to: .enabled)
            return
        }
        
        
        let udacityClient = Udacity.shared
        
        // Authenticate.
        udacityClient.authenticate(with: username, password: password) {
            (success, errorString) in
            
            DispatchQueue.main.async {
                self.setUI(to: .enabled)
                self.activityIndicator.stopAnimating()
            }
            
            if success {
                ControllerCommon.shared.configure()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
            } else {
                DispatchQueue.main.async {
                    ControllerCommon.presentAlertController(forTarget: self, withTitle: "Login Failed", message: errorString!)

                }
            }
        }
        
    }
    
    func loginWithFacebook() {
        
        // Logs in with Facebook.
        
        Udacity.shared.isLogginInWithFacebook = true
        
        FBSDKLoginManager().logIn(withPublishPermissions: nil, from: self) { (result, _) in
            
            if let cancelled = result?.isCancelled, !cancelled {
                if let accessToken = FBSDKAccessToken.current().tokenString {
                
                    self.setUI(to: .disabled)
                    self.activityIndicator.startAnimating()
                
                    Udacity.shared.authenticateWithFacebook(accessToken: accessToken, withCompletionHandler: {
                        (success, errorString) in
                        Udacity.shared.isLogginInWithFacebook = false // Is already logged or failed.
                        DispatchQueue.main.async {
                            self.setUI(to: .enabled)
                            self.activityIndicator.stopAnimating()
                        }
                        if success {
                            ControllerCommon.shared.configure()
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "LoginSegue", sender: self)
                            }
                        } else {
                            DispatchQueue.main.async {
                                ControllerCommon.presentAlertController(forTarget: self, withTitle: "Login Failed", message: errorString!)
                                
                            }
                        }
                    
                    })
                }
            }
        }
    }

}

// MARK: Convenience Methods 

extension LoginViewController {
    
    func setupView() {
        
        // Sets up all the views that need setting up for this controller
        
        // Background
        let backgroundGradient = CAGradientLayer()
        let topColor = UserInterface.Constant.Color.backgroundTop
        let bottomColor = UserInterface.Constant.Color.backgroundBottom
        backgroundGradient.colors = [topColor, bottomColor]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        // Buttons
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.backingColor = UserInterface.Constant.Color.loginOrange
        loginButton.highlightedBackingColor = UserInterface.Constant.Color.loginOrangeDarker
        loginButton.backgroundColor = loginButton.backingColor
        
        facebookButton.addTarget(self, action: #selector(loginWithFacebook), for: .touchUpInside)
        facebookButton.backingColor = UserInterface.Constant.Color.facebookBlue
        facebookButton.highlightedBackingColor = UserInterface.Constant.Color.facebookBlueDarker
        facebookButton.backgroundColor = facebookButton.backingColor
        
        // Textfields
        configure(textField: usernameField)
        configure(textField: passwordField)
        
        // Sign up text view.
        let attributedString = NSMutableAttributedString(string: signUpText.text!)
        let signUpRange = NSMakeRange(signUpText.text!.characters.count - 7, 7)
        
        let attributes =
            [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: ".SFUIText-Light", size: 17)
            ]
        
        let linkAttributes =
            [
                NSForegroundColorAttributeName: UserInterface.Constant.Color.linkBlue,
                NSLinkAttributeName: "https://www.udacity.com/account/auth#!/signup"
            ] as [String : Any]
    
        attributedString.addAttributes(attributes, range: NSMakeRange(0, signUpText.text!.characters.count))
        attributedString.addAttributes(linkAttributes, range: signUpRange)
        signUpText.attributedText = attributedString
        signUpText.textAlignment = .center
        signUpText.delegate = self
        
        setUI(to: .enabled)
    }
    
    func configure(textField: UITextField) {
        
        // Configures a text field
        
        // Delegate
        textField.delegate = self
        
        // Style
        textField.borderStyle = .none
        
        // Field View
        let leftPadding = UIView()
        leftPadding.frame = CGRect(x: 0, y: 0, width: 13, height: 0)
        textField.leftView = leftPadding
        textField.leftViewMode = .always
        
        // Color setup
        textField.backgroundColor = UserInterface.Constant.Color.lazyWhite
        textField.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    
    }
    
    func setUI(to state: UserInterface.UIState) {
        
        // Sets the UI to 'enabled' or 'disabled' mode
        
        switch state {
        case .enabled:
            activityIndicator.isHidden = true
            loginButton.isEnabled = true
            loginButton.alpha = 1
            facebookButton.isEnabled = true
            facebookButton.alpha = 1
            usernameField.isEnabled = true
            passwordField.isEnabled = true
            
        case .disabled:
            activityIndicator.isHidden = false
            loginButton.isEnabled = false
            loginButton.alpha = 0.8
            facebookButton.isEnabled = false
            facebookButton.alpha = 0.8
            usernameField.isEnabled = false
            passwordField.isEnabled = false
        }
    }
    
}

// MARK: Textfield Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Return key designated actions
        
        textField.resignFirstResponder()
        
        if textField === usernameField {
            passwordField.becomeFirstResponder()
            return false
        } else {
            login()
        }
        
        return true
    }
    
}

// MARK: TextView Delegate

extension LoginViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        // Open URL if clicked in 'Sign up'
        return true
    }
    
}
