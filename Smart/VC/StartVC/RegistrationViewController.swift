//
//  RegistrationViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 21..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var nicknameText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var pushState: UISwitch!
    
    @IBOutlet weak var alertText: UILabel!
    var phoneNumber = ""
    
    let genderList = ["성별을 선택해주세요.", "남자", "여자"]
    let pickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertText.text = ""
        
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
        
        nicknameText.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButton(_ sender: Any) {
        if nicknameText.text == "" {
            alert()
            alertText.text = "닉네임을 확인해주세요"
        } else if genderText.text == "" || genderText.text == "성별을 선택해주세요." {
            alert()
            alertText.text = "성별을 확인해주세요"
        } else {
            self.register()
        }
    }
    
    func alert() {
        let alert = UIAlertController(title: "입력정보를 확인해주세요", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem) {
        genderText.resignFirstResponder()
    }
    
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        genderText.resignFirstResponder()
        genderText.text = ""
    }
    
    func setCoreData() {
        var tmpGender = ""
        if self.genderText.text! == "남자" {
            tmpGender = "male"
        } else {
            tmpGender = "female"
        }
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        do {
            let objects = try Library.LibObject.managedObjectContext.fetch(request)
            
            if objects.count > 0 {
                let match = objects[0] as! Profile
                match.setValue(tmpGender, forKey: "gender")
                match.setValue(nicknameText.text!, forKey: "nickname")
                match.setValue(pushState.isOn, forKey: "push")
                
                do {
                    try Library.LibObject.managedObjectContext.save()
                } catch {
                    print("save")
                }
            }
            
        } catch {
            print("coredata")
        }
        
    }
    
    func createCoreData() {
        var tmpGender = ""
        
        if self.genderText.text! == "남자" {
            tmpGender = "male"
        } else {
            tmpGender = "female"
        }
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let contact = Profile(entity: entityDescription!, insertInto: Library.LibObject.managedObjectContext)
        
        contact.nickname = nicknameText.text!
        contact.imageid = ""
        contact.push = pushState.isOn
        contact.gender = tmpGender
        contact.phoneNumber = ""
        print(contact)
        do {
            try Library.LibObject.managedObjectContext.save()
        } catch {
            print("coredata catch")
        }
    }
    
    func register() {
        let deviceId = UIDevice().identifierForVendor?.uuidString
        let url = URL(string: Library.LibObject.url + "/auth/3")
        var request = URLRequest(url: url!)
        
        var tmpGender = ""
        
        if self.genderText.text! == "남자" {
            tmpGender = "male"
        } else {
            tmpGender = "female"
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["deviceId" : "\(deviceId!)", "sex" : "\(tmpGender)", "push" : "\(self.pushState.isOn)", "nick" : "\(self.nicknameText.text!)", "id" : "\(self.phoneNumber)"]
        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    
                    let httpResponse = response as! HTTPURLResponse
                    
                    if httpResponse.statusCode == 200 {
                        self.setCoreData()
                        self.registerSegue()
                    } else {
                        print("auth3 error")
                    }
//                    do {
//                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
//                        let checkJSON = parseJSON["result"] as? String
//
//                        if checkJSON == "1" {
//
//                        } else {
//                            print("에러에러")
//                        }
//                    } catch {
//                        print("catch")
//                    }
                }
            }
        }) .resume()
    }
    
    func registerSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "registerSegue", sender: self)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nicknameText {
            guard let text = textField.text else {
                return true
            }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10
        }
        
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
