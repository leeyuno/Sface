//
//  ReplyViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 28..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, replyCellDelegate {
    
    var replyObject = [[AnyObject]]()
    var productId = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var replyText: UITextField!
    @IBOutlet weak var replyButton: UIButton!
    
    var replyId = ""
    var replyKey = ""

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
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(image: UIImage(named: "hideKeyboard"), style: .done, target: self, action: #selector(keyboardDown))
        
        toolBar.setItems([space, done], animated: false)
        replyText.isUserInteractionEnabled = true
        replyText.inputAccessoryView = toolBar
        
        self.configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "replyCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "replyCell")
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func replyFunc() {
        let url = URL(string: Library.LibObject.url + "/reply")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(Library.LibObject.phoneNumber)", "product_id" : "\(self.productId)", "text" : "\(self.replyText.text!)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print(response!)
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.replyText.resignFirstResponder()
                        self.replyText.text = ""
                        self.reloadReply()
                    }
                }
            }
        }) .resume()
    }
    
    func replyReply(_ replyKey: String, _ replyId: String) {
        print("답글쓰기")
        
        replyReplySegue()
        
        self.replyId = replyId
        self.replyKey = replyKey
    }
    
    func reloadReply() {
        replyObject.removeAll()
        let url = URL(string: Library.LibObject.url + "/hotproduct/click")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["_id" : "\(self.productId)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let arrJSON = parseJSON["result"] as! [String: AnyObject]
                        
                        let replyArray = arrJSON["reply"] as! NSArray
                        
                        if replyArray.count > 0 {
                            for i in 0 ... replyArray.count - 1 {
                                let replyItem = replyArray[i] as! [String: AnyObject]
                                self.replyObject.append([replyItem["_id"] as AnyObject, replyItem["id"] as AnyObject, replyItem["key"] as AnyObject, replyItem["nick"] as AnyObject, replyItem["text"] as AnyObject])
                            }
                        }
                        self.configureTableView()
                    } catch {
                        print("catch error")
                    }
                }
            }
        }) .resume()
    }
    
    @IBAction func replyButton(_ sender: Any) {
        self.replyFunc()
    }
    
    func replyReplySegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "replyReplySegue", sender: self)
        }
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
        replyText.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyObject.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //해당 게시글 소유자가 아닐경우 -> 답글쓰기 버튼 숨김
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! replyCell
        
        if replyObject[indexPath.row][2] as? String != nil {
            cell.backgroundColor = UIColor.lightGray
            cell.replyButton.isHidden = true
        }
        
        if replyObject[indexPath.row][0] as? String != nil {
            cell.replyId = self.replyObject[indexPath.row][0] as! String
        }
        
        if replyObject[indexPath.row][2] as? String != nil {
            cell.replyKey = replyObject[indexPath.row][2] as! String
        }
        
        cell.nickname.text = self.replyObject[indexPath.row][3] as? String
        cell.profileImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/profile/\(replyObject[indexPath.row][1]).jpg"))
        cell.contents.text = self.replyObject[indexPath.row][4] as? String
        cell.replyCellDelegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        replyText.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "replyReplySegue" {
            let vc = segue.destination as! replyReplyViewController
            vc.replyObject = self.replyObject
            vc.replyId = self.replyId
            vc.replyKey = self.replyKey
            vc.productId = self.productId
        }
    }
 

}
