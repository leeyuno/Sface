//
//  noticeCell.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 24..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class noticeCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var contents: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
