//
//  ViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-10-03.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON
import CoreLocation
import FirebaseAuth
import JGProgressHUD
import NotificationBannerSwift

class RestaurantListViewController: UITableViewController, CLLocationManagerDelegate {
    
    var restaurants = [Restaurant]()
    let locationManager = CLLocationManager()
    var location: CLLocation!
    let API_KEY = Security.API_KEY
    let hud = JGProgressHUD(style: .dark)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        hud.textLabel.text = "Loading"
        hud.show(in: self.view, animated: true)
        
       
    
        
        // Row styling
        
        tableView.rowHeight = 70.0
        
        // Location Config
        self.locationManager.requestWhenInUseAuthorization()
        if !CLLocationManager.locationServicesEnabled() {
            print("Locations services are not enabled!")
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
//         tableView.register(RestaurantCell.self, forCellReuseIdentifier: "RestaurantCell")
        
        assignRefreshControl()
        
    }
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - TableView Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        
        if !restaurants.isEmpty {
            hud.dismiss(afterDelay: 1.0, animated: true) // Dismiss loading hud when array is populated.
        }
        
        cell.setLabels(restaurant: restaurant)
        
        
        
        return cell
    }
    
    
    //MARK: - Networking
    
    func getRestaurant(url: String, params: [String:String]) {
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                print("Response sucessful!")
                let restaurantJSON = JSON(response.result.value!)
                self.getDataFromJSON(json: restaurantJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    // MARK: - Parsing JSON and Creating instances of the restaurant class
    
    func getDataFromJSON(json: JSON) {
        for (_, subJSON) in json["results"] {
            
            let restaurantName = subJSON["name"].string ?? ""
            let restaurantAddress = subJSON["formatted_address"].string ?? ""
            let restaurantRating = subJSON["rating"].float ?? 0.0
            let restaurantIsOpen = subJSON["opening_hours"]["open_now"].bool ?? false
            let restaurantPriceLevel = subJSON["price_level"].int ?? 0
            let restaurantLat = subJSON["geometry"]["location"]["lat"].double ?? 0
            let restaurantLng = subJSON["geometry"]["location"]["lng"].double ?? 0
            let restaurantID = subJSON["place_id"].string ?? ""
            
            let newRestaurant = Restaurant(name: restaurantName, address: restaurantAddress, rating: restaurantRating, priceLevel: restaurantPriceLevel, isOpen: restaurantIsOpen, lat: restaurantLat, lng: restaurantLng, id: restaurantID)
            
            if newRestaurant.priceLevel != 0 {
                restaurants.append(newRestaurant)
            }
        }
        
        
        //Initial array sorted by rating
        restaurants.sort { $0.rating > $1.rating}
        
        
        self.tableView.reloadData()
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil // is this legal? lol
            
            let latitute = location.coordinate.latitude
            let longitute = location.coordinate.longitude
            let query = "ramen restaurant"
            let params = ["query": query, "location": "\(latitute),\(longitute)", "radius": "1000", "key": API_KEY ]
            
            
            let GOOGLE_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json"
            getRestaurant(url: GOOGLE_URL, params: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
        print("Error updating location! \(error)")
    }
    
    //MARK: - Refresh Data
    
    func assignRefreshControl() {
        let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

           if #available(iOS 10.0, *) {
               tableView.refreshControl = refreshControl
           } else {
               tableView.backgroundView = refreshControl
           }
    }
    
    // Refreshing table view with new data

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        restaurants.removeAll() // Cleaning up restaurants array to avoid duplciate data
        
        hud.show(in: self.view, animated: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation() // Checking for newest user location
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        hud.dismiss(afterDelay: 1.0, animated: true)
    }
    
    
    //MARK: - Segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToRestaurant" {
            let destinationVC = segue.destination as! RestaurantViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.restaurant = restaurants[indexPath.row]
                destinationVC.userLocation = location
            }
        }
        
    }
    
    
    
}

//MARK: - Extension Implementing View Picker










