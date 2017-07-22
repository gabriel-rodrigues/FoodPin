//
//  RestauranteTableViewCell.swift
//  FoodPin
//
//  Created by Gabriel Rodrigues on 09/07/17.
//  Copyright © 2017 Gabriel Rodrigues. All rights reserved.
//

import UIKit

class RestauranteTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
