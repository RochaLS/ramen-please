//
//  WelcomeViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-11-16.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Auth.auth().currentUser)

        // Do any additional setup after loading the view.
    }

}
