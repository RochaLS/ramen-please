//
//  ProfileViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-11-18.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            
            print("User Signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBAction func goToFavoritesPressed(_ sender: UIButton) {
    }
    
    
}
