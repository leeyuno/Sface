//
//  profileCell.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 28..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class profileCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
