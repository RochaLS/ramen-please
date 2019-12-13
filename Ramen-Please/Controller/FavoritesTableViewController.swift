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
//import SwiftyJSON
import SwipeCellKit
import JGProgressHUD

class FavoritesTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let hud = JGProgressHUD(style: .dark)
    var favoriteRestaurants = [Restaurant]()
    
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hud.show(in: self.view, animated: true)
        
        gettingDataFromDB()
        
        
        
        print(ref)
    }
    
    
    
    // MARK: - Table view data source and Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteRestaurants.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRestaurantCell", for: indexPath) as! FavoritesTableViewCell
        
        // Configure the cell...
        
        cell.delegate = self
        
        
        cell.setLabel(restaurant: favoriteRestaurants[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = favoriteRestaurants[sourceIndexPath.row]
        favoriteRestaurants.remove(at: sourceIndexPath.row)
        favoriteRestaurants.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.deleteCell(at: indexPath)
            
            
        }
        
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = UIColor(hexString: "#E94F4F")
        
        
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            deleteCell(at: indexPath)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func deleteCell(at indexPath: IndexPath) {
        let restaurantRef = ref.child("Users").child(userID!).child("Restaurants").child(favoriteRestaurants[indexPath.row].id)
        favoriteRestaurants.remove(at: indexPath.row)
        restaurantRef.removeValue()
        print("Item deleted")
        // No need to reload table view here, already reloading when observing
    }
    
    
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
        
    }
    
    //MARK: - Getting data from DB
    
    func gettingDataFromDB() {
        var data = [String:Any]()
        ref.child("Users").child(userID!).child("Restaurants").observe(.value, with: { (snapshot) in
            
            if let restaurantData = snapshot.value as? NSDictionary {
                
                // Remove all items before observing again to avoid duplicated Items on the table view.
                self.favoriteRestaurants.removeAll()
                
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
                }
                self.hud.dismiss(afterDelay: 1.0, animated: true)
                self.tableView.reloadData() // reloading here
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
