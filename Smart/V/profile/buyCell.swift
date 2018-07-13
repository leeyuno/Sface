//
//  buyCell.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 20..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class buyCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var leftTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        name.layer.masksToBounds = true
        name.layer.cornerRadius = 5
        name.layer.borderColor = UIColor.black.cgColor
        name.layer.borderWidth = 1.0
        name.backgroundColor = UIColor.white
        name.textColor = UIColor.black
        
        price.layer.masksToBounds = true
        price.layer.cornerRadius = 5
        
        date.layer.masksToBounds = true
        date.layer.cornerRadius = 5
        
//        productImage.layer.masksToBounds = true
//        productImage.layer.cornerRadius = 10
//        productImage.layer.borderColor = UIColor.lightGray.cgColor
//        productImage.layer.borderWidth = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
