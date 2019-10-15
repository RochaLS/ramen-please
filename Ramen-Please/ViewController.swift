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

class ViewController: UITableViewController, CLLocationManagerDelegate {
    
    var restaurants = [Restaurant]()
    let locationManager = CLLocationManager()
    var didFindLocation = false
    let GOOGLE_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    let API_KEY = "AIzaSyDy7W-43K8pRLP-wnja0KuqoNBnat5FQjc"
    

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RamenCell", for: indexPath)
        cell.textLabel?.text = restaurants[indexPath.row].name
        cell.textLabel?.font = UIFont(name:"Arial Rounded MT" , size: 16)
        return cell
    }
    
    //MARK: - Networking
    
    func getRestaurant(url: String, params: [String:String]) {
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                print("Response sucessful!")
                let restaurantJSON = JSON(response.result.value!)
                print(url)
                self.updateRestaurantData(json: restaurantJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    // MARK: - Parsing JSON and Creating instances of the restaurant class
    
    func updateRestaurantData(json: JSON) {
        for (_, subJSON) in json["results"] {
            let newRestaurant = Restaurant()
            
            if let restaurantName = subJSON["name"].string {
                newRestaurant.name = restaurantName

                
                restaurants.append(newRestaurant)
            }
            if let restaurantAddress = subJSON["formatted_address"].string {
                newRestaurant.address = restaurantAddress
            }
            if let restaurantRating = subJSON["rating"].int {
                newRestaurant.rating = restaurantRating
            }
        }
        self.tableView.reloadData()
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        restaurants = []
        let location = locations.last!
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil // is this legal? lol
            
            let latitute = location.coordinate.latitude
            let longitute = location.coordinate.longitude
            
//            print(latitute)
//            print(longitute)
            
            let query = "ramen restaurant"
            let params = ["query": query, "location": "\(latitute),\(longitute)", "radius": "1500", "key": API_KEY ]
            
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }

}

