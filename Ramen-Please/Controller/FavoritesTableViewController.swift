//
//  FavoritesTableViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-11-18.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SwiftyJSON

class FavoritesTableViewController: UITableViewController {
    
    var favoriteRestaurants = [Restaurant]()
    
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingDataFromDB()
        
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteRestaurants.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRestaurantCell", for: indexPath) as! FavoritesTableViewCell
        
        // Configure the cell...
        
        cell.setLabel(restaurant: favoriteRestaurants[indexPath.row])
        
        return cell
    }
    
    func gettingDataFromDB() {
        var data = [String:Any]()
        ref.child("Users").child(userID!).child("Restaurants").observe(.value, with: { (snapshot) in
            
            if let restaurantData = snapshot.value as? NSDictionary {
                for (_, value) in restaurantData{
                    data = value as! [String : Any]
                    let restaurantName = data["name"] as! String
                    let restaurantLat = data["lat"] as! Double
                    let restaurantLng = data["lng"] as! Double
                    let restaurantAddress = data["address"] as! String
                    let restaurantID = data["id"] as! String
                    let restaurantRating = data["rating"] as! Float
                    let restaurantPriceLevel = data["priceLevel"] as! Int
                    
                    let favoriteRestaurant = Restaurant(name: restaurantName, address: restaurantAddress, rating: restaurantRating, priceLevel: restaurantPriceLevel, isOpen: false, lat: restaurantLat, lng: restaurantLng, id: restaurantID)
                    self.favoriteRestaurants.append(favoriteRestaurant)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favToRestaurant" {
            let destinationVC = segue.destination as! FavoriteRestaurantViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.restaurant = favoriteRestaurants[indexPath.row]
                print(favoriteRestaurants[indexPath.row].name)
            }
        }
    }

    
    
}
