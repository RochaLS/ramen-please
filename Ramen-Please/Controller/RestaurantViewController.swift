//
//  RestaurantViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-10-15.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import Firebase


class RestaurantViewController: UIViewController {
    
    var restaurant: Restaurant!
    var userLocation: CLLocation!
    let API_KEY = Security.API_KEY
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var priceL1: UILabel!
    @IBOutlet weak var priceL2: UILabel!
    @IBOutlet weak var priceL3: UILabel!
    @IBOutlet weak var priceL4: UILabel!
    @IBOutlet weak var map: GMSMapView!
    
   

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUIWithRestaurantInfo()
        mapConfig()
        
       
        
        
    }
    
    func updateUIWithRestaurantInfo() {
        restaurantNameLabel.text = restaurant.name
        ratingLabel.textColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0.2235294118, alpha: 1)
        if restaurant.rating == 0 {
            ratingLabel.text = "Rating: --"
        } else {
            ratingLabel.text = "Rating: \(String(restaurant.rating))"
        }
        
        priceLevelStyling()
        
        if restaurant.isOpen {
            openLabel.text = "Open"
            openLabel.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
        } else {
            openLabel.text = "Closed"
            openLabel.textColor = #colorLiteral(red: 0.9896159768, green: 0.1559592187, blue: 0.1507968903, alpha: 1)
        }
    }
    
    func priceLevelStyling() {
        switch restaurant.priceLevel {
        case 1:
            priceL1.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
        case 2:
            priceL1.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
            priceL2.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
        case 3:
            priceL1.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
            priceL2.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
            priceL3.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
        case 4:
            priceL1.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
            priceL2.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
            priceL3.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
            priceL4.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
        
        default:
            print("Colors applied")
        }
    }
    
    // MARK: - Map Configuration
    
    func mapConfig() {
        let origin = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let destination = CLLocationCoordinate2D(latitude: restaurant.lat! , longitude: restaurant.lng!)
        
        // Setting bounds for the camera, so the camera can show both destination and origin on the map
        let bounds = GMSCoordinateBounds(coordinate: origin, coordinate: destination)
        
        // Creating camera
        let camera = GMSCameraPosition.camera(withLatitude: Double(restaurant.lat!), longitude: Double(restaurant.lng!), zoom: 14)
        
        map.camera = camera
        map.isMyLocationEnabled = true
        
        
        do {
          // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: traitCollection.userInterfaceStyle == .dark ? "NightMap" : "Default", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        
        // Inserting markers into the map
        let position = CLLocationCoordinate2D(latitude: restaurant.lat!, longitude: restaurant.lng!)
        let marker = GMSMarker(position: position)
        
        marker.title = restaurant.name
        marker.snippet = restaurant.address
        marker.map = map
        
        //Updating camera with the previous bounds
        
        let updateCamera = GMSCameraUpdate.fit(bounds)
        map.animate(with: updateCamera)
        
        //Getting and drawing route
        getRoute()
    }
    
    func drawRoute(json: JSON) {
        if let polylinePoints = json["routes"][0]["overview_polyline"]["points"].string {
            let path = GMSPath(fromEncodedPath: polylinePoints)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 6.0
            polyline.spans = [GMSStyleSpan(color: #colorLiteral(red: 1, green: 0.2995484173, blue: 0.253780663, alpha: 1))]
            polyline.map = map
        
        }
    }
    
// MARK: - Networking
    
    func getRoute() {
        let url = "https://maps.googleapis.com/maps/api/directions/json?"
        let params = ["origin": "\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)", "destination": "\(restaurant.lat!),\(restaurant.lng!)", "key": API_KEY ]
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                print("Response sucessful!")
                let routeJSON = JSON(response.result.value!)
//                print(url)
//                print(routeJSON)
                self.drawRoute(json: routeJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        let restaurantsDB = Database.database().reference().child("RestaurantInfo")
        let restaurantDict = ["name": restaurant.name, "address": restaurant.address, "rating": restaurant.rating, "priceLevel": restaurant.priceLevel!, "lat": restaurant.lat!, "lng": restaurant.lng!] as [String : Any]
        
        restaurantsDB.childByAutoId().setValue(restaurantDict) {
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Data Saved!")
            }
        }
        
    }
}

