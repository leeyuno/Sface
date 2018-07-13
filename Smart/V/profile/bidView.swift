//
//  bidView.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 12..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class bidView: UITableViewCell {

    @IBOutlet weak var bidImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var nowPrice: UILabel!
    @IBOutlet weak var leftTime: UILabel!
    
    var time: Double!
    var productId = ""
    
    var timer: Timer!
    
    @IBOutlet weak var bidPrice: UILabel!
    @IBOutlet weak var myPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bidImage.layer.masksToBounds = true
        bidImage.layer.cornerRadius = 2
        
        bidPrice.layer.masksToBounds = true
        bidPrice.layer.cornerRadius = 5
        
        myPrice.layer.masksToBounds = true
        myPrice.layer.cornerRadius = 5
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(currentTime), userInfo: nil, repeats: true)
        
//        bidImage.layer.masksToBounds = true
//        bidImage.layer.cornerRadius = 10
//        bidImage.layer.borderColor = UIColor.lightGray.cgColor
//        bidImage.layer.borderWidth = 0.3
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
