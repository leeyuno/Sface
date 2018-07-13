//
//  RegisterViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 10..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class RegisterViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var registerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var numberCheck: UITextField!
    @IBOutlet weak var compareCheck: UILabel!
    
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var pushState: UISwitch!
    
    @IBOutlet weak var genderText: UITextField!
    let genderList = ["남자", "여자"]
    let pickerView = UIPickerView()
    
    var compareCheckBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.checkAuth(false)
        compareCheck.text = "인증을 먼저 진행해주세요."
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneAction(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelAction(_:)))
        
        toolBar.setItems([cancel, space, done], animated: false)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        genderText.inputAccessoryView = toolBar
        genderText.inputView = pickerView
        
        numberCheck.delegate = self
        phoneNumber.delegate = self
        
        numberCheck.isEnabled = false
//        compareCheck.isHidden = true
        
        configureScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem) {
        genderText.resignFirstResponder()
    }
    
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        genderText.resignFirstResponder()
        genderText.text = ""
    }
    
    func checkAuth(_ check: Bool) {
        if check {
            nickName.isEnabled = true
            genderText.isEnabled = true
            pushState.isEnabled = true
        } else {
            nickName.isEnabled = false
            genderText.isEnabled = false
            pushState.isEnabled = false
        }
    }
    
    func createCoreData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let contact = Profile(entity: entityDescription!, insertInto: Library.LibObject.managedObjectContext)
        
        contact.nickname = nickName.text!
        contact.imageid = ""
        
        do {
            try Library.LibObject.managedObjectContext.save()
        } catch {
            print("coredata catch")
        }
        
    }
    
    func configureScrollView() {
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.view.frame.size.height)
        scrollView.addSubview(registerView)
    }
    
    @IBAction func postButton(_ sender: Any) {
        if phoneNumber.text != "" {
            if postButton.titleLabel?.text! == "인증번호받기" {
                numberCheck.isEnabled = true
                receiveNumber()
            } else if postButton.titleLabel?.text! == "인증받기" {
                self.checkNumber()
            }
        } else {
            self.postAlert()
        }
    }
    
    //인증번호가 전송되었다는 창
    func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "인증번호가 전송되었습니다", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //인증번호 받는함수
    func receiveNumber() {
        let url = URL(string: Library.LibObject.url + "/auth/1")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["id" : "\(self.phoneNumber.text!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    self.successAlert()
                }
            }
            
        }) .resume()
    }
    
    //인증번호가 일치하는지 체크하는 함수
    func checkNumber() {
        let url = URL(string: Library.LibObject.url + "/auth/2")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(self.phoneNumber.text!)", "sigNum" : "\(self.numberCheck.text)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    self.checkAuth(true)
                    self.compareCheck.text = "정보를 입력해주세요."
                }
            }
        }) .resume()
    }
    
    func register() {
        let deviceId = UIDevice().identifierForVendor?.uuidString
        let url = URL(string: Library.LibObject.url + "/auth/3")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["deviceId" : "\(deviceId!)", "sex" : "\(self.genderText.text!)", "push" : "\(self.pushState.isOn)", "nick" : "\(self.nickName.text!)", "id" : ""]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    self.createCoreData()
                    self.registerSegue()
                }
            }
        }) .resume()
    }
    
    func postAlert() {
        let alert = UIAlertController(title: "전화번호오류", message: "전화번호를 확인해주세요", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func registerSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "registerSegue", sender: self)
        }
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButton(_ sender: Any) {
        if nickName.text! != "" && genderText.text! != "" {
            self.register()
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "입력값 오류", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumber.resignFirstResponder()
        numberCheck.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //인증번호가 일치, 불일치 결과 출력
        if textField == numberCheck {
            if compareCheckBool {
                compareCheck.isHidden = false
                compareCheck.text = "일치합니다"
            } else {
                compareCheck.isHidden = false
                compareCheck.text = "일치하지 않습니다"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderList[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderText.text = genderList[row]
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "registerSegue" {
            let vc = segue.destination as! TabBarViewController
            vc.nickname = self.nickName.text!
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
