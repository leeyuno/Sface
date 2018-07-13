//
//  CompareViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 21..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController {

    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var nickname2: UITextField!
    
    var id = ""
    var compareText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nickname.text = compareText
    }
    
    func postCheckNickname() {
        let deviceId = UIDevice().identifierForVendor?.uuidString
        let url = URL(string: Library.LibObject.url + "/login/3")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(self.id)", "nick" : "\(self.nickname2.text!)", "deviceId" : "\(deviceId!)"]
        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print(response!)
                let httpResponse = response as! HTTPURLResponse
                
                if httpResponse.statusCode == 200 {
                    print("성공")
                    self.loginSegue()
                } else {
                    print("실패")
                }
            }
        }) .resume()
    }
    
    func loginSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButton(_ sender: Any) {
        if nickname2.text != "" {
            self.postCheckNickname()
//            self.loginSegue()
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "닉네임을 입력해주세요", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
