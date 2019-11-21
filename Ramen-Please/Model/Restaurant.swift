//
//  Restaurant.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-10-04.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//
import GooglePlaces
import Foundation

class Restaurant {
    var name = ""
    var address = ""
    var rating: Float = 0
    var priceLevel: Int?
    var isOpen = false
    var lat: Double?
    var lng: Double?
    let id: String
    
    init(name: String, address: String, rating: Float, priceLevel: Int?, isOpen: Bool, lat: Double?, lng: Double?, id: String) {
        self.name = name
        self.address = address
        self.rating = rating
        self.priceLevel = priceLevel
        self.isOpen = isOpen
        self.lat = lat
        self.lng = lng
        self.id = id
    }
}
