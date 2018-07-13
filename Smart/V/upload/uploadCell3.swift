//
//  uploadCell3.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 14..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

protocol uploadCellDelegate: class {
    func textViewTappedReturn()
}

class uploadCell3: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    weak var uploadCellDelegate: uploadCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
        textView.textColor = UIColor.lightGray
        textView.text = "게시글 내용을 입력해주세요"
        
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
        textView.inputAccessoryView = KtoolBar
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func keyboardHide() {
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            uploadCellDelegate?.textViewTappedReturn()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.black
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGray
            textView.text = "게시글 내용을 입력해주세요"
        }
    }

}
