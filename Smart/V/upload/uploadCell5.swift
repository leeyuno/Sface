//
//  uploadCell5.swift
//  Smart
//
//  Created by leeyuno on 2018. 2. 1..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class uploadCell5: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var tag1: UITextField!
    @IBOutlet weak var tag2: UITextField!
    @IBOutlet weak var tag3: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let KtoolBar = UIToolbar()
        KtoolBar.barStyle = .default
        KtoolBar.isTranslucent = true
        KtoolBar.tintColor = UIColor.black
        KtoolBar.sizeToFit()
        
        let Kspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let Kdone = UIBarButtonItem(image: UIImage(named: "hideKeyboard"), style: .done, target: self, action: #selector(keyboardHide))
        KtoolBar.setItems([Kspace, Kdone], animated: false)
        KtoolBar.isUserInteractionEnabled = true
        
        tag1.inputAccessoryView = KtoolBar
        tag2.inputAccessoryView = KtoolBar
        tag3.inputAccessoryView = KtoolBar
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tag1.resignFirstResponder()
        tag2.resignFirstResponder()
        tag3.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardHide() {
        tag1.resignFirstResponder()
        tag2.resignFirstResponder()
        tag3.resignFirstResponder()
    }

}
