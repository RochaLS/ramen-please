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
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUIWithRestaurantInfo()
    }
    
    func updateUIWithRestaurantInfo() {
        restaurantNameLabel.text = restaurant.name
        ratingLabel.text = "\(String(restaurant.rating))"
        if restaurant.priceLevel < 1 {
            priceLevelLabel.text = "$"
        } else {
            priceLevelLabel.text = String(repeating: "$", count: restaurant.priceLevel)
        }
        
        if restaurant.isOpen {
            openLabel.text = "Open!"
        } else {
            openLabel.text = "Closed"
        }
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
