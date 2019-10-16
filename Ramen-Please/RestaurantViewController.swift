//
//  RestaurantViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-10-15.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    var restaurant: Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(restaurant.name)
        print(restaurant.address)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
