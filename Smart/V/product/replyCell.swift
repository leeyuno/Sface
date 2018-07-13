//
//  replyCell.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 24..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

protocol replyCellDelegate: class {
    func replyReply(_ replyKey: String, _ replyId: String)
}

class replyCell: UITableViewCell {
    
    weak var replyCellDelegate: replyCellDelegate?

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var contents: UILabel!
    
    var replyId = ""
    var replyKey = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        replyButton.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var replyButton: UIButton!
    
    @IBAction func replyButton(_ sender: Any) {
        replyCellDelegate?.replyReply(replyKey, replyId)
    }
    
}
