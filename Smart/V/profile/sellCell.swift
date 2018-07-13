//
//  sellCell.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 3..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class sellCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var leftTime: UILabel!
    @IBOutlet weak var nowPrice: UILabel!
    
    var time: Double!
    var productId = ""
    
    var timer: Timer!
    
    @IBOutlet weak var now: UILabel!
    
    @IBOutlet weak var bidCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        now.layer.masksToBounds = true
        now.layer.cornerRadius = 5
        
        leftTime.layer.masksToBounds = true
        leftTime.layer.cornerRadius = 5
        
        productImage.layer.masksToBounds = true
        productImage.layer.cornerRadius = 5
        
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(currentTime), userInfo: nil, repeats: true)
        
        bidCountLabel.layer.masksToBounds = true
        bidCountLabel.layer.cornerRadius = 10
        bidCountLabel.layer.borderWidth = 1.0
        bidCountLabel.layer.borderColor = UIColor.black.cgColor
        
        likeCountLabel.layer.masksToBounds = true
        likeCountLabel.layer.cornerRadius = 10
        likeCountLabel.layer.borderWidth = 1.0
        likeCountLabel.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func currentTime() {
        self.time = self.time - 1.0
        if self.time < 0 {
            leftTime.text = "판매종료"
            timer.invalidate()
        } else {
            let stringFromTime = self.convertTime(time)
            leftTime.text = stringFromTime
        }
    }

    func convertTime(_ time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60

        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

}
