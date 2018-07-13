//
//  TabBarViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 13..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker
import Foundation
import Alamofire
import CoreData

var selectedTab = 0

class TabBarViewController: UITabBarController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    var nowSelected: Int!
    var imageCount: Int!
    var timeisSelected = false
    
    var nickname: String?
    var gender: String?
    var imageid: String?
//    var writeStatus = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageList = [UIImage]()
    @IBOutlet var writeView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var tag1Text: UITextField!
    @IBOutlet weak var tag2Text: UITextField!
    @IBOutlet weak var tag3Text: UITextField!
    //    @IBOutlet weak var imageTable: UITableView!
    
    @IBOutlet weak var titleText: UITextField!
    
    var imageNameList = [String]()
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectImage: UIImageView!
    
    @IBOutlet weak var categoryText: UITextField!
    
    let pickList = ["디지털/가전", "스포츠/레저/취미", "키덜트/피규어/소장", "차량/오토바이", "남성의류", "남성패션/잡화", "여성의류", "여성패션/잡화", "뷰티/미용", "유아/출산", "인테리어/가구/장식", "예술/음반", "티켓/상품권/쿠폰", "기타"]

    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreData()
        
        self.navigationItem.hidesBackButton = true
        self.title = "핫아이템"
        // Do any additional setup after loading the view.
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(donePressed(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelPressed(_:)))
        
        toolBar.setItems([cancel, space, done], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        categoryText.inputAccessoryView = toolBar
        
        pickerView.delegate = self
        categoryText.inputView = pickerView
        
        let nib = UINib(nibName: "uploadCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell1")
        
        let nib2 = UINib(nibName: "uploadCell2", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "cell2")
        
        let nib3 = UINib(nibName: "uploadCell3", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "cell3")
        
        let nib4 = UINib(nibName: "uploadCell4", bundle: nil)
        tableView.register(nib4, forCellReuseIdentifier: "cell4")
        
        let nib5 = UINib(nibName: "uploadCell5", bundle: nil)
        tableView.register(nib5, forCellReuseIdentifier: "cell5")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardDidHide, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(actionSheet))
        selectImage.isUserInteractionEnabled = true
        selectImage.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func coreData() {
        let deviceId = UIDevice().identifierForVendor?.uuidString
        let url = URL(string: Library.LibObject.url + "/mypage/view")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(Library.LibObject.phoneNumber)", "deviceId" : "\(deviceId!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let checkJSON = parseJSON["result"] as? String
                        
                        if checkJSON == "0" {
                            print("핫아이템 데이터없음")
                        } else {
                            let arrJSON = parseJSON["result"] as! [String: AnyObject]
                            
                            let myProfile = arrJSON["profile"] as! [String: AnyObject]
                            self.nickname = myProfile["nick"] as? String
                            self.gender = myProfile["sex"] as? String
                            //                        self.imageid = arrJSON["image"] as? String
                            
                            let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
                            let request = NSFetchRequest<NSFetchRequestResult>()
                            
                            request.entity = entityDescription
                            
                            do {
                                let objects = try Library.LibObject.managedObjectContext.fetch(request)
                                
                                if objects.count > 0 {
                                    let match = objects[0] as! Profile
                                    
                                    match.nickname = self.nickname
                                    match.imageid = self.imageid
                                    match.gender = self.gender
                                    
                                    Library.LibObject.imageid = Library.LibObject.phoneNumber + ".jpg"
                                    Library.LibObject.nickname = self.nickname!
                                }
                            } catch {
                                print("asdfasdf")
                            }
                        }
                    } catch {
                        print("catch error")
                    }
                }
            }
        }) .resume()
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isScrollEnabled = true
        collectionView.reloadData()
    }
    
    func textViewTappedReturn(_ notification: Notification) {

        print("Resturn")
    }
    
    @objc func actionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "카메라", style: .default, handler: { void in
            self.cameraAction()
        })
        
        let album = UIAlertAction(title: "앨범에서 선택", style: .default, handler: { void in
            self.albumAction()
        })
        
        let imageCancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(album)
        actionSheet.addAction(imageCancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //글 데이터 전송함수
    
    func sendWriteData() {
        //임시 데이터 테스트
//        let tmpCategoryText = self.categoryText.text!
        var value = [UInt32]()
        var tmpTime: NSNumber!

        for _ in 0 ... Library.LibObject.imageArray.count - 1 {
            let tmpValue = arc4random()
            value.append(tmpValue)
            imageNameList.append("\(Library.LibObject.phoneNumber)_\(tmpValue).jpg")
        }

        let cell1 = tableView.cellForRow(at: [0, 0]) as! uploadCell4
        let cell2 = tableView.cellForRow(at: [0, 1]) as! uploadCell5
        let cell3 = tableView.cellForRow(at: [0, 2]) as! uploadCell
        let cell4 = tableView.cellForRow(at: [0, 3]) as! uploadCell2
        let cell5 = tableView.cellForRow(at: [0, 4]) as! uploadCell3

        let tmpTitleText = cell3.titleText.text!
        let tmpMaximum = cell4.maximum.text!
        let tmpMinimum = cell4.minimum.text!
        let tmpContents = cell5.textView.text!
        
        if cell1.time6.isSelected {
            tmpTime = 6
        } else if  cell1.time12.isSelected {
            tmpTime = 12
        } else if  cell1.time18.isSelected {
            tmpTime = 18
        } else if  cell1.time24.isSelected {
            tmpTime = 24
        }
        
        var tmpHashTag = [String]()

        tmpHashTag.append(cell2.tag1.text!)
        tmpHashTag.append(cell2.tag2.text!)
        tmpHashTag.append(cell2.tag3.text!)

        //임시 데이터 테스트
        let url = URL(string: Library.LibObject.url + "/upload/1")
        var request = URLRequest(url: url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json: [String: Any] = ["category" : self.categoryText.text!, "title" : tmpTitleText, "start_Bid" : tmpMinimum, "final_Bid" : tmpMaximum, "time" : tmpTime!, "writer" : Library.LibObject.phoneNumber, "text" : tmpContents, "tag" : tmpHashTag  , "image" : self.imageNameList]
        print(json)

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in

            if error != nil{
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {

                    let httpResponse = response as! HTTPURLResponse
                    print(response!)
//                    print(httpResponse.statusCode)
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            print("22222")
                            self.initWriteView()
                        }
                        self.removeWriteView()
                    }

                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary

                    } catch {
                        print("catch error")
                    }

//                    self.writeStatus = false
                }
            }
        }) .resume()
    }
    
    func fileUploads() {
        Alamofire.upload(multipartFormData: { multipartFormData in
            for i in 0 ... Library.LibObject.imageArray.count - 1 {
                let imageData = UIImageJPEGRepresentation(Library.LibObject.imageArray[i], 0.5)
                multipartFormData.append(imageData!, withName: "product", fileName: self.imageNameList[i], mimeType: "image/*")
            }
            
        }, to: Library.LibObject.url + "/upload/product", encodingCompletion: {encodingResult in
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
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButton(_ sender: Any) {
        let cell1 = tableView.cellForRow(at: [0, 0]) as! uploadCell4
//        let cell2 = tableView.cellForRow(at: [0, 1]) as! uploadCell5
        let cell3 = tableView.cellForRow(at: [0, 2]) as! uploadCell
        let cell4 = tableView.cellForRow(at: [0, 3]) as! uploadCell2
        let cell5 = tableView.cellForRow(at: [0, 4]) as! uploadCell3
        
        if Library.LibObject.imageArray.count == 0 || cell1.timeisSelected == false || cell3.titleText.text == "" || cell4.maximum.text == "" || cell4.minimum.text == "" || cell5.textView.text == "" || categoryText.text == "" {
            print("데이터가 정상적으로 입력되지 않음")
        } else {
            self.sendWriteData()
            self.fileUploads()
            Library.LibObject.writeState = false
        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    func cameraAction() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.show(picker, sender: nil)
    }
    
    func albumAction() {
        let picker = BSImagePickerViewController()
        picker.maxNumberOfSelections = 5
        
        bs_presentImagePickerController(picker, animated: true,
                                        select: { (asset: PHAsset) -> Void in
//                                            print("Selected: \(asset)")

        }, deselect: { (asset: PHAsset) -> Void in
//            print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
//            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
//            print("Finish: \(assets)")
            self.createImage(assets)
        }, completion: nil)
    }
    
    func createImage(_ assets: [PHAsset]) {
        self.imageCount = assets.count
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        
        option.isSynchronous = true
        
        DispatchQueue.main.async {
            for i in 0 ... assets.count - 1 {
                manager.requestImage(for: assets[i], targetSize: CGSize(width: 600.0, height: 600.0), contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in
                    self.imageList.append(result!)
                    Library.LibObject.imageArray.append(result!)
                })
            }
            self.configureCollectionView()
        }
    }
    
    //작성중이었는지 체크후 띄어주는 경고창
    func writeCheck() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let load = UIAlertAction(title: "불러오기", style: .default, handler: { action in
            self.makeWriteView()
        })
        
        let delete = UIAlertAction(title: "새로작성", style: .default, handler: { action in
            self.initWriteView()
            
            self.makeWriteView()
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { action in
            self.selectedIndex = selectedTab
            Library.LibObject.writeState = true
        })
        
        alert.addAction(load)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func initWriteView() {
        Library.LibObject.imageArray.removeAll()
        
        print(Library.LibObject.imageArray.count)
        
        self.categoryText.text = ""
        self.imageList.removeAll()
        self.collectionView.reloadData()
        
        let cell1 = self.tableView.cellForRow(at: [0, 0]) as! uploadCell4
        let cell2 = self.tableView.cellForRow(at: [0, 1]) as! uploadCell5
        let cell3 = self.tableView.cellForRow(at: [0, 2]) as! uploadCell
        let cell4 = self.tableView.cellForRow(at: [0, 3]) as! uploadCell2
        let cell5 = self.tableView.cellForRow(at: [0, 4]) as! uploadCell3
        
        cell1.timeisSelected = false
        cell1.time6.isSelected = false
        cell1.time12.isSelected = false
        cell1.time18.isSelected = false
        cell1.time24.isSelected = false
        cell2.tag1.text = ""
        cell2.tag2.text = ""
        cell2.tag3.text = ""
        cell3.titleText.text = ""
        cell4.minimum.text = ""
        cell4.maximum.text = ""
        cell5.textView.text = ""
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.items?.index(of: item) == 2 {
            self.checkWriteView()
        } else if tabBar.items?.index(of: item) == 0 {
            self.title = "핫아이템"
        } else if tabBar.items?.index(of: item) == 1 {
            self.title = "카테고리"
        } else if tabBar.items?.index(of: item) == 3 {
            self.title = "채팅"
        } else if tabBar.items?.index(of: item) == 4 {
            self.title = "프로필"
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        removeWriteView()
        Library.LibObject.writeState = true
    }
    
    func removeWriteView() {
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
            self.selectedIndex = selectedTab
            self.navigationController?.navigationBar.isHidden = false
        } else {
            print("errororororo123")
        }
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem) {
        categoryText.resignFirstResponder()
    }
    
    @objc func cancelPressed(_ sender: UIBarButtonItem) {
        categoryText.text = ""
        categoryText.resignFirstResponder()
    }
    
    @objc func keyboardShow(_ notification: Notification) {
        if categoryText.isEditing {
            if ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue) != nil {

                self.writeView.frame.origin.y = 0

                self.writeView.frame.origin.y -= 40
            }
        } else {
            let keyboardFrame: CGRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            if ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue) != nil {

                self.writeView.frame.origin.y = 0

                self.writeView.frame.origin.y -= keyboardFrame.size.height - 60
            }
        }

//        let keyboardFrame = (notification.userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue

    }

    @objc func keyboardHide(_ notification: Notification) {
        if ((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue) != nil {
            self.writeView.frame.origin.y = UIApplication.shared.statusBarFrame.height
        }
    }

    func timeAlert() {
        let alert = UIAlertController(title: "시간은 한개만 선택 가능합니다.", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardDown() {
        tag1Text.resignFirstResponder()
        tag2Text.resignFirstResponder()
        tag3Text.resignFirstResponder()
        tableView.endEditing(true)
    }
    
    func checkWriteView() {
        if Library.LibObject.writeState == true {
            writeCheck()
        } else {
            makeWriteView()
        }
    }
    
    func makeWriteView() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.topView.layer.borderColor = UIColor.lightGray.cgColor
        self.topView.layer.borderWidth = 0.3
        
        self.writeView.frame = CGRect(x: self.view.frame.origin.x, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.writeView.tag = 1
        
        self.view.addSubview(writeView)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        Library.LibObject.imageArray.append(selectedImage)
        
        self.configureCollectionView()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryText.text = pickList[row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 5
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView {
            if indexPath.row == 4 {
                return 200
            } else {
                return 44.0
            }
        } else {
            return 64.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! uploadCell4
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! uploadCell5
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! uploadCell
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! uploadCell2
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! uploadCell3
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Library.LibObject.imageArray.count != nil {
            
            if Library.LibObject.imageArray.count >= 5 {
                return 5
            } else {
                return Library.LibObject.imageArray.count
            }
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.image.image = Library.LibObject.imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Library.LibObject.imageArray.remove(at: indexPath.item)
        collectionView.reloadData()
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
