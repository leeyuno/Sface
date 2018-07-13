//
//  itemView.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 12..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class itemView: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var nowPrice: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    
    @IBOutlet weak var now: UILabel!
    @IBOutlet weak var max: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        now.layer.masksToBounds = true
        now.layer.cornerRadius = 5
        
        max.layer.masksToBounds = true
        max.layer.cornerRadius = 5
        
        timeLeft.layer.masksToBounds = true
        timeLeft.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
