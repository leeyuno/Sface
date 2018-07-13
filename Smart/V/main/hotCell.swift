//
//  hotCell.swift
//  Smart
//
//  Created by leeyuno on 2018. 2. 20..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class hotCell: UITableViewCell {

    @IBOutlet weak var hotImage: UIImageView!
    @IBOutlet weak var hotPrice: UILabel!
    @IBOutlet weak var hotTime: UILabel!
    
    var time: Double!
    var timer: Timer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(currentTime), userInfo: nil, repeats: true)
        
        hotTime.backgroundColor = UIColor.lightGray
        hotTime.layer.masksToBounds = true
        hotTime.layer.cornerRadius = 3
        hotTime.layer.borderColor = UIColor.lightGray.cgColor
        hotTime.layer.borderWidth = 0.2
        hotTime.textColor = UIColor.white
        hotTime.sizeToFit()
        //        timeWidthCOnstraint.constant = leftTime.frame.size.width + 5
        
        hotPrice.backgroundColor = UIColor.lightGray
        hotPrice.layer.masksToBounds = true
        hotPrice.layer.cornerRadius = 3
        hotPrice.layer.borderColor = UIColor.lightGray.cgColor
        hotPrice.layer.borderWidth = 0.2
        hotPrice.textColor = UIColor.white
        hotPrice.sizeToFit()
        //        widthConstraint.constant = nowPrice.frame.size.width + 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func currentTime() {
        self.time = self.time - 1.0
        if self.time < 0 {
            hotTime.text = "판매종료"
            timer.invalidate()
        } else {
            let stringFromTime = self.convertTime(time)
            hotTime.text = stringFromTime
        }
    }
    
    func convertTime(_ time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

}
