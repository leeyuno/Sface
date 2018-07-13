//
//  productSettingCell.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 9..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

protocol productSettingDelegate: class {
    func replySegue()
}

class productSettingCell: UITableViewCell {

    @IBOutlet weak var numberOfReply: UILabel!
    
    weak var productSettingDelegate: productSettingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func replyButton(_ sender: Any) {
        productSettingDelegate?.replySegue()
    }
    
}
