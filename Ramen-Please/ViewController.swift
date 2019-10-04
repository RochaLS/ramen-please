//
//  ViewController.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-10-03.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var restaurants = ["Test1", "Test2", "Test 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RamenCell", for: indexPath)
        
        cell.textLabel?.text = restaurants[indexPath.row]
        return cell
    }

}

