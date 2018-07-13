//
//  textViewCell.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 9..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class textViewCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.sizeToFit()
        
//        print(textView.frame.size.height)
//        print(textView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
