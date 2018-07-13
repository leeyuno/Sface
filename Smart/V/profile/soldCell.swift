//
//  soldCell.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 3..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class soldCell: UITableViewCell {

    var productId = ""
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDate: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productImage.layer.masksToBounds = true
        productImage.layer.cornerRadius = 2
        
        priceLabel.layer.masksToBounds = true
        priceLabel.layer.cornerRadius = 10
        
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 10
        
//        bidImage.layer.masksToBounds = true
//        bidImage.layer.cornerRadius = 10
//        bidImage.layer.borderColor = UIColor.lightGray.cgColor
//        bidImage.layer.borderWidth = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
