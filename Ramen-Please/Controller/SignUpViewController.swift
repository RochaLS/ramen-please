//
//  SignUpViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-11-16.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.placeholder = "Email Address"
        passwordTextField.placeholder = "Password"
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        print("test")
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.errorLabel.text = error?.localizedDescription
                    self.errorLabel.textColor = #colorLiteral(red: 0.9137254902, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
                    print("Error when Signing up: \(error!)")
                } else {
                    self.performSegue(withIdentifier: "SignUpToRestaurants", sender: self)
                    print("User Created")
                }
            }
        }
    }
    
}
