//
//  FavoritesTableViewCell.swift
//  Ramen-Please
//
//  Created by Lucas Rocha on 2019-11-19.
//  Copyright © 2019 Lucas Rocha. All rights reserved.
//

import UIKit
import SwipeCellKit

class FavoritesTableViewCell: SwipeTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    func setLabel(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
    }

}
