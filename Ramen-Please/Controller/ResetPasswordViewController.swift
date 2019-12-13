//
//  ResetPasswordViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-12-12.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import FirebaseAuth
import NotificationBannerSwift

class ResetPasswordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        if textField.text != "" || textField.text != nil {
            Auth.auth().sendPasswordReset(withEmail: textField.text!) { (error) in
                if error != nil {
                    let banner = NotificationBanner(title: "Something is wrong!", subtitle: "\(error!.localizedDescription)", style: .danger)
                    banner.show(on: self)
                    print("Error: \(error.debugDescription)")
                } else {
                    let banner = NotificationBanner(title: "Success!", subtitle: "Email with password reset instructions sent to your account!", style: .success)
                    banner.show(on: self)
                    print("Reset email sent!")
                }
            }
        }
    }
    
}
