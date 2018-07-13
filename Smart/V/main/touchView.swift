//
//  touchView.swift
//  Smart
//
//  Created by leeyuno on 2018. 2. 7..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class touchView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subView: UIView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        imageView.backgroundColor = UIColor.white
        
        subView.layer.masksToBounds = true
        subView.layer.cornerRadius = subView.frame.size.height / 2
    }
 

}
