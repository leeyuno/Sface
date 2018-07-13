//
//  uploadCell.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 14..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class uploadCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleText.delegate = self
        
        let KtoolBar = UIToolbar()
        KtoolBar.barStyle = .default
        KtoolBar.isTranslucent = true
        KtoolBar.tintColor = UIColor.black
        KtoolBar.sizeToFit()
        
        let Kspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        //        let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(keyboardDown))
        let Kdone = UIBarButtonItem(image: UIImage(named: "hideKeyboard"), style: .done, target: self, action: #selector(keyboardHide))
        KtoolBar.setItems([Kspace, Kdone], animated: false)
        KtoolBar.isUserInteractionEnabled = true
        titleText.inputAccessoryView = KtoolBar

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleText.resignFirstResponder()
    }
    
    func test() {
        
        print(titleText.text!)
    }
    
    @objc func keyboardHide() {
        titleText.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
