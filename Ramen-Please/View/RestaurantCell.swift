//
//  RestaurantCell.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-10-23.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {


    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabels(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        ratingLabel.text = String(restaurant.rating)
        ratingLabel.textColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0.2235294118, alpha: 1)
        priceLabel.text = String(repeating: "$", count: restaurant.priceLevel!)
        priceLabel.textColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1)
        isOpenLabel.text = restaurant.isOpen ? "Open" : "Closed"
        isOpenLabel.textColor = restaurant.isOpen ? #colorLiteral(red: 0, green: 0.7411764706, blue: 0.337254902, alpha: 1) : #colorLiteral(red: 0.9896159768, green: 0.1559592187, blue: 0.1507968903, alpha: 1)
        
        
        
    }

}
