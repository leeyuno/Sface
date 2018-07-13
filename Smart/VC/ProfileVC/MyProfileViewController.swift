//
//  MyProfileViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 14..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import Alamofire

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var nickName = ""
    var imageid = ""
    var phoneNumber = ""
    var gender = ""
    
    var GenderList = ["남자", "여자"]
    let pickerView = UIPickerView()
    @IBOutlet weak var nickNameText: UITextField!
    @IBOutlet weak var genderText: UITextField!
//    @IBOutlet weak var pushState: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        nickNameText.placeholder = nickName
        
        if gender == "male" {
            genderText.placeholder = "남자"
        } else {
            genderText.placeholder = "여자"
        }

        pickerView.delegate = self
        pickerView.dataSource = self
        nickNameText.delegate = self
        
        // Do any additional setup after loading the view.
        
        if imageid == "" {
            imageView.image = UIImage(named: "boy")
        } else {
            imageView.kf.setImage(with: URL(string: Library.LibObject.url + "/download/profile/\(imageid)"))
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(actionSheet))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        self.navigationItem.title = "프로필"
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneAction(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelAction(_:)))
        
        toolBar.setItems([cancel, space, done], animated: false)
        genderText.inputAccessoryView = toolBar
        genderText.inputView = pickerView
        
        let keyboardSlideDown = UISwipeGestureRecognizer(target: self, action: #selector(keyboardDown))
        keyboardSlideDown.direction = .down
        self.view.addGestureRecognizer(keyboardSlideDown)
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButton(_:)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardDown() {
        nickNameText.resignFirstResponder()
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem) {
        genderText.resignFirstResponder()
    }
    
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        genderText.resignFirstResponder()
        genderText.text = ""
    }
    
    @objc func keyboardUp(_ notification: Notification) {
        if ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue) != nil {
            self.view.frame.origin.y = 0
            
            self.view.frame.origin.y -= 30
        }
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        if ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue) != nil {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func actionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let album = UIAlertAction(title: "앨범에서 선택", style: .default, handler: { Void in
            self.albumAction()
        })
        let camera = UIAlertAction(title: "카메라", style: .default, handler: { Void in
            self.cameraAction()
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func albumAction() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.show(picker, sender: self)
    }
    
    func cameraAction() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.show(picker, sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = selectedImage
    }

    func loadImage() {
        let url = URL(string: Library.LibObject.url + "/download/profile/\(self.imageid)")
        imageView.kf.setImage(with: url!)
    }
    
    func saveCoreData() {
        var tmpGender = ""
        if self.genderText.text! == "남자" {
            tmpGender = "male"
        } else {
            tmpGender = "female"
        }
        
        let eneityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = eneityDescription
        
        do {
            let objects = try Library.LibObject.managedObjectContext.fetch(request)
            
            if objects.count > 0 {
                let match = objects[0] as! Profile
                match.setValue(self.nickNameText.text!, forKey: "nickname")
                match.setValue(tmpGender, forKey: "gender")
//                match.setValue(self.pushState.isOn, forKey: "push")
                match.setValue(Library.LibObject.phoneNumber, forKey: "phoneNumber")
                match.setValue(Library.LibObject.phoneNumber + ".jpg", forKey: "imageid")
                do {
                    try Library.LibObject.managedObjectContext.save()
                } catch {
                    print("ssave error")
                }
            }
        } catch {
            print("sa")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveData() {
        let deviceId = UIDevice().identifierForVendor?.uuidString
        let url = URL(string: Library.LibObject.url + "/mypage/update")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var tmpGenderText = ""
        var tmpNickText = ""
        
        if self.genderText.text! == "" {
            tmpGenderText = self.genderText.placeholder!
        } else {
            tmpGenderText = self.genderText.text!
        }
        
        if self.nickNameText.text! == "" {
            tmpNickText = self.nickNameText.placeholder!
        } else {
            tmpNickText = self.nickNameText.text!
        }
        
        let json = ["id" : "\(Library.LibObject.phoneNumber)", "deviceId" : "\(deviceId!)", "image" : "\(Library.LibObject.phoneNumber).jpg", "push" : "\(true)", "sex" : "\(tmpGenderText)", "nick" : "\(tmpNickText)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        self.saveCoreData()
                    }
                }
            }
            
        }) .resume()
    }
    
    func saveImage() {
//        DispatchQueue.main.async {
            Alamofire.upload(multipartFormData: { multipartFormData in
                DispatchQueue.main.async {
                    let imageData = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    multipartFormData.append(imageData!, withName: "profile", fileName: "\(Library.LibObject.phoneNumber).jpg", mimeType: "image/*")
                }
            }, to: Library.LibObject.url + "/upload/profile", encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _) :
                    upload.responseJSON(completionHandler: { response in
                        debugPrint(response)
                    })
                case .failure(let encodingError) :
                    print(encodingError)
                }
            })
        }
//    }
    
    @IBAction func doneButton(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        saveData()
        saveImage()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GenderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GenderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderText.text = GenderList[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nickNameText {
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
