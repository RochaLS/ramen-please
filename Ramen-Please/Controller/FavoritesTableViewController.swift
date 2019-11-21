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
    
    var favoriteRestaurants = [String]()
    
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
        
        cell.setLabel(restaurantName: favoriteRestaurants[indexPath.row])

        return cell
    }
    
    func gettingDataFromDB() {
        var data = [String:Any]()
        ref.child("Users").child(userID!).child("Restaurants").observe(.value, with: { (snapshot) in
            
            if let restaurantData = snapshot.value as? NSDictionary {
                for (_, value) in restaurantData{
                  data = value as! [String : Any]
                  let restaurantName = (data["name"] as! String)
                  self.favoriteRestaurants.append(restaurantName)
                  print(self.favoriteRestaurants.count)
                  self.tableView.reloadData()
              }
            }
        })
    }
}
