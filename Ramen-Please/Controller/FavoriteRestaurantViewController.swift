//
//  FavoriteRestaurantViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-11-21.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import GoogleMaps

class FavoriteRestaurantViewController: UIViewController {
    
    var restaurant : Restaurant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        mapConfig()
    }
    
    func mapConfig() {
        let camera = GMSCameraPosition.camera(withLatitude: restaurant.lat!, longitude: restaurant.lng!, zoom: 18)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: traitCollection.userInterfaceStyle == .dark ? "NightMap" : "Default", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        let position = CLLocationCoordinate2D(latitude: restaurant.lat!, longitude: restaurant.lng!)
        let marker = GMSMarker(position: position)
        
        marker.snippet = restaurant.name
        marker.map = mapView
        
        self.view = mapView
    }
    
}
