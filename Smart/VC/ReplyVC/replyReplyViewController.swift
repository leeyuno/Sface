//
//  replyReplyViewController.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 3..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class replyReplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var replyText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    //replyObject에서 replyArray로 필요한 댓글 배열을 생성
    var replyObject = [[AnyObject]]()
    var replyArray = [[AnyObject]]()
    var replyId = ""
    var replyKey = ""
    var productId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardDidHide, object: nil)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.backgroundColor = UIColor.lightGray
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(image: UIImage(named: "hideKeyboard"), style: .done, target: self, action: #selector(keyboardDown))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([space, done], animated: false)
        
        replyText.isUserInteractionEnabled = true
        replyText.inputAccessoryView = toolBar
        
        updateReplyArray()
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "replyCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "replyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
    }
    
    func updateReplyArray() {
        for i in 0 ... replyObject.count - 1 {
            if replyObject[i][0] as! String == replyId {
                replyArray.append(replyObject[i])
            }
            
            if replyObject[i][2] as? String != nil {
                if replyObject[i][2] as! String == replyId {
                    replyArray.append(replyObject[i])
                }
            }
        }
    }
    
    func replyReply() {
        replyText.becomeFirstResponder()
        
        let url = URL(string: Library.LibObject.url + "/reply/2")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(Library.LibObject.phoneNumber)", "product_id" : "\(self.productId)", "text" : "\(self.replyText.text!)", "reply_key" : "\(replyKey)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
            }
        })
    }
    
    @IBAction func submitButton(_ sender: Any) {
        self.replyReply()
    }
    
    @objc func keyboardShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue) != nil {
            self.view.frame.origin.y = 0
            
            self.view.frame.origin.y -= keyboardFrame.size.height
        }
        
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        if ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue) != nil {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardDown() {
        replyText.text = ""
        replyText.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! replyCell
        
        if replyArray[indexPath.row][2] as? String != nil {
            cell.backgroundColor = UIColor.lightGray
            cell.replyButton.isHidden = true
        }
        
        cell.replyButton.isHidden = true
        
        cell.nickname.text = replyArray[indexPath.row][3] as? String
        cell.contents.text = replyArray[indexPath.row][4] as? String
        cell.profileImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/profile/\(replyArray[indexPath.row][1]).jpg"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyArray.count
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        replyText.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
