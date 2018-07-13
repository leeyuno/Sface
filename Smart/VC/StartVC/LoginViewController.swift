//
//  ViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 10..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var alertText: UILabel!
    
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var compareNumberText: UITextField!
    var compareText = ""
    
    var nickname = ""
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadCoreData()
        
        //해당 디바이스에 폰넘버가 저장되어있지 않으면 자동로그인 x, 수동로그인으로 유저체크
        if phoneNumber != nil {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                self.autoLogin()
//                self.setting()
//            })
            self.autoLogin()
            self.setting()
        }
        alertText.text = ""
        compareNumberText.isEnabled = false
        loginButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setting() {
        loginButton.layer.cornerRadius = 10
    }
    
    func registerSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "registerSegue", sender: self)
        }
    }
    
    func loginSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    func compareSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "compareSegue", sender: self)
        }
    }
    
    func autoLogin() {
        let token = Messaging.messaging().fcmToken
        
        let deviceId = UIDevice().identifierForVendor?.uuidString
        let url = URL(string: Library.LibObject.url + "/dcmr")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let json = ["deviceId" : "\(deviceId!)", "id" : "\(self.phoneNumber!)", "token" : "\(token!)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                print(response!)
                if httpResponse.statusCode == 201 {
                    self.loginSegue()
                } else if httpResponse.statusCode == 200 {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
//                        print(parseJSON)
                    } catch {
                        print("메시지 캐치")
                    }
                } else if httpResponse.statusCode == 222 {
                    self.registerSegue()
                } else {
                    print(httpResponse.statusCode)
                }
            }
            
        }) .resume()
    }
    
    func createCoreData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let contact = Profile(entity: entityDescription!, insertInto: Library.LibObject.managedObjectContext)
        
        contact.nickname = ""
        contact.imageid = ""
        contact.push = true
        contact.gender = ""
        contact.phoneNumber = self.phoneNumberText.text!
        Library.LibObject.phoneNumber = self.phoneNumberText.text!
        Library.LibObject.imageid = ""
        Library.LibObject.nickname = ""
        do {
            try Library.LibObject.managedObjectContext.save()
        } catch {
            print("coredata catch")
        }
    }
    
    func loadCoreData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        
        request.entity = entityDescription
        
        do {
            let objects = try Library.LibObject.managedObjectContext.fetch(request)
            
            if objects.count > 0 {
                let match = objects[0] as! Profile
                self.phoneNumber = match.value(forKey: "phoneNumber") as? String
                Library.LibObject.phoneNumber = match.value(forKey: "phoneNumber") as! String
                Library.LibObject.imageid = match.value(forKey: "imageid") as! String
                Library.LibObject.nickname = match.value(forKey: "nickname") as! String
            }
        } catch {
            print("coredata error")
        }
        
    }
    
    @IBAction func postButton(_ sender: Any) {
        if phoneNumberText.text != "" {
            if postButton.titleLabel?.text! == "인증번호받기" {
                compareNumberText.isEnabled = true
                receiveNumber()
//                postButton.setTitle("인증하기", for: .normal)
            } else if postButton.titleLabel?.text! == "인증하기" {
                self.checkNumber()
            }
        } else {
            self.postAlert()
        }
    }
    
    func receiveNumber() {
        let url = URL(string: Library.LibObject.url + "/login/1")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["id" : "\(self.phoneNumberText.text!)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    self.successAlert()
                    DispatchQueue.main.async {
                        self.postButton.setTitle("인증하기", for: .normal)
                    }
                } else {
                    print("login1 실패")
                }
            }
        }) .resume()
        
    }
    
    //인증번호가 일치하는지 체크하는 함수
    func checkNumber() {
        let deviceId = UIDevice().identifierForVendor?.uuidString
        let url = URL(string: Library.LibObject.url + "/login/2")
        var request = URLRequest(url: url!)
        
        createCoreData()
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(self.phoneNumberText.text!)", "sigNum" : "\(self.compareNumberText.text!)", "deviceId" : "\(deviceId!)"]
//        print(json)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
//                    print(response!)
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            do {
                                let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                                self.loginSegue()
                            } catch {
                                print("catch")
                            }
                        }
                    } else if httpResponse.statusCode == 300 {
                        self.registerSegue()
                    } else if httpResponse.statusCode == 333 {
                        do {
                            let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
//                            let checkJSON = parseJSON["result"] as! String
                            self.compareText = parseJSON["result"] as! String
                            
                        } catch {
                            print("비교")
                        }
                        self.compareSegue()
                    } else {
                        self.alertText.text = "인증번호가 일치하지 않습니다."
                        print("인증번호 틀림")
                    }
                }
            }
        }) .resume()
    }
    
    func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "인증번호가 전송되었습니다", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func postAlert() {
        let alert = UIAlertController(title: "전화번호오류", message: "전화번호를 확인해주세요", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
//        if idText.text! == "" && pwdText.text! == "" {
//            let alert = UIAlertController(title: "아이디, 패스워드 오류", message: "아이디, 패스워드를 확인해주세요", preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
//
//            alert.addAction(cancel)
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            self.loginSegue()
//        }
        self.loginSegue()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "compareSegue" {
            let vc = segue.destination as! CompareViewController
            vc.id = self.phoneNumberText.text!
            vc.compareText = self.compareText
//            vc.nickname.text = self.nickname
        } else if segue.identifier == "registerSegue" {
            let vc = segue.destination as! RegistrationViewController
            vc.phoneNumber = self.phoneNumberText.text!
        }
    }

}

