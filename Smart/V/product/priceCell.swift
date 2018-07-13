//
//  priceCell.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 9..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class priceCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var startPrice: UILabel!
    @IBOutlet weak var nowPrice: UILabel!
    @IBOutlet weak var endPrice: UILabel!
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var startViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var startHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nowView: UIView!
    @IBOutlet weak var nowViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var nowViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var endViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var endViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
//        startPrice.layer.masksToBounds = true
//        startPrice.layer.cornerRadius = startPrice.frame.size.height / 2
//
//        nowPrice.layer.masksToBounds = true
//        nowPrice.layer.cornerRadius = nowPrice.frame.size.height / 2
//
//        endPrice.layer.masksToBounds = true
//        endPrice.layer.cornerRadius = endPrice.frame.size.height / 2
        
//        startPrice.layer.masksToBounds = true
//        startPrice.layer.cornerRadius = 2
//        startPrice.layer.borderWidth = 0.3
//        startPrice.layer.borderColor = UIColor.black.cgColor
//        startPrice.sizeToFit()
//        startViewWidthConstraint.constant = startPrice.frame.size.width + 10
//        startHeightConstraint.constant = startPrice.frame.size.height + 5
        
//        nowPrice.layer.masksToBounds = true
//        nowPrice.layer.cornerRadius = 5
//        nowPrice.layer.borderWidth = 0.3
//        nowPrice.layer.borderColor = UIColor.black.cgColor
//        nowPrice.sizeToFit()
//        nowViewWidthConstraint.constant = nowPrice.frame.size.width + 10
//        nowViewHeightConstraint.constant = nowPrice.frame.size.height + 5
        
//        endPrice.layer.masksToBounds = true
//        endPrice.layer.cornerRadius = 5
//        endPrice.layer.borderWidth = 0.3
//        endPrice.layer.borderColor = UIColor.black.cgColor
//        endPrice.sizeToFit()
//        endViewWidthConstraint.constant = endPrice.frame.size.width + 10
//        endViewHeightConstraint.constant = endPrice.frame.size.height + 5
        
        startView.layer.masksToBounds = true
        startView.layer.cornerRadius = startView.frame.size.height / 2
        
        nowView.layer.masksToBounds = true
        nowView.layer.cornerRadius = nowView.frame.size.height / 2
        
        endView.layer.masksToBounds = true
        endView.layer.cornerRadius = endView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        endPrice.sizeThatFits(CGSize(width: endPrice.frame.size.width + 5, height: endPrice.frame.size.height + 5))

    }

}
