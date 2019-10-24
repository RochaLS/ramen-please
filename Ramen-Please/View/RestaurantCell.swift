//
//  RestaurantCell.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-10-23.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var secondaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabels(restaurant: Restaurant) {
        self.textLabel?.text = restaurant.name
        self.textLabel?.font = UIFont(name:"Arial Rounded MT" , size: 16)
        secondaryLabel.text = String(restaurant.rating)
        secondaryLabel.font = UIFont(name:"Arial Rounded MT" , size: 16)
        secondaryLabel.textColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0.2235294118, alpha: 1)
    }

}
