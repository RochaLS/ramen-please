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
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RootNav") as! UINavigationController
        
        do {
            try firebaseAuth.signOut()
            // Changing root back again to he first nav of the app
            self.view.window?.rootViewController = controller
            navigationController?.popToRootViewController(animated: true)
//            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            print("User Signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func dismissViewControllers() {

        guard let vc = self.presentingViewController else { return }

        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func goToFavoritesPressed(_ sender: UIButton) {
        
    }
    
    
}
