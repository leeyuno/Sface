//
//  tagCell.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 9..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class tagCell: UITableViewCell {

    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
