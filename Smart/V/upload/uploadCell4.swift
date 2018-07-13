//
//  uploadCell4.swift
//  Smart
//
//  Created by leeyuno on 2018. 2. 1..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class uploadCell4: UITableViewCell {
    
    @IBOutlet weak var time6: UIButton!
    @IBOutlet weak var time12: UIButton!
    @IBOutlet weak var time18: UIButton!
    @IBOutlet weak var time24: UIButton!
    
    var timeisSelected: Bool!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timeisSelected = false
        
        time6.layer.masksToBounds = true
        time6.layer.borderColor = UIColor.black.cgColor
        time6.layer.borderWidth = 0.3
        time6.layer.cornerRadius = 5
        
        time12.layer.masksToBounds = true
        time12.layer.borderColor = UIColor.black.cgColor
        time12.layer.borderWidth = 0.3
        time12.layer.cornerRadius = 5
        
        time18.layer.masksToBounds = true
        time18.layer.borderColor = UIColor.black.cgColor
        time18.layer.borderWidth = 0.3
        time18.layer.cornerRadius = 5
        
        time24.layer.masksToBounds = true
        time24.layer.borderColor = UIColor.black.cgColor
        time24.layer.borderWidth = 0.3
        time24.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func time6(_ sender: Any) {
        if time6.isSelected {
            time6.isSelected = false
            timeisSelected = false
        } else {
            if timeisSelected == true {
//                self.timeAlert()
            } else {
                time6.isSelected = true
                timeisSelected = true
            }
        }
    }
    @IBAction func time12(_ sender: Any) {
        if time12.isSelected {
            time12.isSelected = false
            timeisSelected = false
        } else {
            if timeisSelected == true {
//                self.timeAlert()
            } else {
                time12.isSelected = true
                timeisSelected = true
            }
        }
    }
    @IBAction func time18(_ sender: Any) {
        if time18.isSelected {
            time18.isSelected = false
            timeisSelected = false
        } else {
            if timeisSelected == true {
//                self.timeAlert()
            } else {
                time18.isSelected = true
                timeisSelected = true
            }
        }
    }
    @IBAction func time24(_ sender: Any) {
        if time24.isSelected {
            time24.isSelected = false
            timeisSelected = false
        } else {
            if timeisSelected == true {
//                self.timeAlert()
            } else {
                time24.isSelected = true
                timeisSelected = true
            }
        }
    }
    
}
