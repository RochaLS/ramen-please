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

class RestaurantListViewController: UITableViewController, CLLocationManagerDelegate {
    
    var restaurants = [Restaurant]()
    let locationManager = CLLocationManager()
    var location: CLLocation!
    let API_KEY = Security.API_KEY
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        
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
            
            let newRestaurant = Restaurant(name: restaurantName, address: restaurantAddress, rating: restaurantRating, priceLevel: restaurantPriceLevel, isOpen: restaurantIsOpen, lat: restaurantLat, lng: restaurantLng)
            
            restaurants.append(newRestaurant)
        }
        self.tableView.reloadData()
//        print(restaurants.count)
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        restaurants = []
        location = locations.last!
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil // is this legal? lol
            
            let latitute = location.coordinate.latitude
            let longitute = location.coordinate.longitude
            
//            print(latitute)
//            print(longitute)
            
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
    
    //MARK: - Segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RestaurantViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.restaurant = restaurants[indexPath.row]
            destinationVC.userLocation = location
        }
    }

}

