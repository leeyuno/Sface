//
//  HotView.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 12..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

protocol HotViewDelegate: class {
    func productSegue(_ id: Int)
}

class HotView: UIView {
    
    weak var hotViewDelegate: HotViewDelegate?
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeWidthCOnstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTime: UILabel!
    @IBOutlet weak var nowPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var id = ""
    var time: Double!
    
    var timer: Timer!
    
    var tagNumber: Int!
    
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
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        leftTime.backgroundColor = UIColor.lightGray
        leftTime.layer.masksToBounds = true
        leftTime.layer.cornerRadius = 3
        leftTime.layer.borderColor = UIColor.lightGray.cgColor
        leftTime.layer.borderWidth = 0.2
        leftTime.textColor = UIColor.white
        leftTime.sizeToFit()
        timeWidthCOnstraint.constant = leftTime.frame.size.width + 5
        
        nowPrice.backgroundColor = UIColor.lightGray
        nowPrice.layer.masksToBounds = true
        nowPrice.layer.cornerRadius = 3
        nowPrice.layer.borderColor = UIColor.lightGray.cgColor
        nowPrice.layer.borderWidth = 0.2
        nowPrice.textColor = UIColor.white
//        nowPrice.sizeThatFits(CGSize(width: 100, height: nowPrice.frame.size.height))
        nowPrice.sizeToFit()
        widthConstraint.constant = nowPrice.frame.size.width + 5
//        nowPrice.sizeToFit()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(currentTime), userInfo: nil, repeats: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.sendTag))
        
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func sendTag() {
        hotViewDelegate?.productSegue(self.tag)
    }

}
