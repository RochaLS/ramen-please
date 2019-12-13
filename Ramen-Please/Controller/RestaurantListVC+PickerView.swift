//
//  RestaurantListVC+PickerView.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-12-12.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit

extension RestaurantListViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    var picker: UIPickerView {
        return UIPickerView()
    }
    var choices: [String] {
        return ["Rating", "Most Expensive", "Cheapest"]
    }
    
    // Creating alert show the pickerview
    
    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sort by:", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPresentation = true
        
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140)) // Positioning picker frame
        alert.view.addSubview(pickerFrame)
        
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Picker view data source and delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row]
    }
    
    
    //Sorting restaurants array when selecting row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var sortedRestaurants = [Restaurant]()
        if choices[row] == "Rating" {
            sortedRestaurants = restaurants.sorted { $0.rating > $1.rating}
        } else if choices[row] == "Most Expensive" {
            sortedRestaurants = restaurants.sorted { $0.priceLevel! > $1.priceLevel!}
        } else if choices[row] == "Cheapest" {
            sortedRestaurants = restaurants.sorted { $0.priceLevel! < $1.priceLevel!}
        }
        
        restaurants = sortedRestaurants
        tableView.reloadData()
    }
}

