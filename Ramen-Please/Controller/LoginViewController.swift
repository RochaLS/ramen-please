//
//  LoginViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-11-16.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import FirebaseAuth
import NotificationBannerSwift

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.placeholder = "Email Address"
        passwordTextField.placeholder = "Password"
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    print("Error on login.")
                    let banner = NotificationBanner(title: "Something is wrong!", subtitle: "\(error!.localizedDescription)", style: .danger)
                    banner.show(on: self)
                    self.errorLabel.text = error?.localizedDescription
                    self.errorLabel.textColor = #colorLiteral(red: 0.9137254902, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
                } else {
                    self.performSegue(withIdentifier: "LoginToRestaurants", sender: self)
                    print("User Logged in!")
                }
            }
        }
    }
    

    
}
