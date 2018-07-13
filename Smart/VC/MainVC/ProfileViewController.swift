//
//  ProfileViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 13..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class ProfileViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UITableViewDelegate, UICollectionViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var subView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noticeTable: UITableView!
    
    let noticeItem = ["공지사항", "고객센터", "어플공유", "리뷰 남기기"]
    let collectionItem = ["구매내역", "판매내역", "내입찰"]
    let collectionItemImage = ["shopping", "doller", "bid"]
    
    var imageId: String?
    var nickname: String?
    var gender: String?
    
    var myBidObject = [[AnyObject]]()
    var hoProduct = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.loadData()

        // Do any additional setup after loading the view.
        selectedTab = self.tabBarItem.tag
//        self.configureScrollView()
//        self.configureTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        
        self.navigationController?.navigationBar.topItem?.title = "프로필"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting2"), style: .plain, target: self, action: #selector(settingAction))
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @objc func settingAction() {
        self.settingSegue()
    }
    
    func settingSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "settingSegue", sender: self)
        }
    }
    
    func qnaSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "qnaSegue", sender: self)
        }
    }
    
    func configureTableView() {
        self.profileTable.bounces = false
        self.noticeTable.bounces = false
        self.profileTable.isScrollEnabled = false
        self.noticeTable.isScrollEnabled = false
        
        self.profileTable.delegate = self
        self.profileTable.dataSource = self
        self.noticeTable.delegate = self
        self.noticeTable.dataSource = self
    }
    
    func configureScrollView() {
        scrollView.delegate = self
        scrollView.bounces = false
        
        scrollView.frame = CGRect(x: self.view.frame.origin.x, y: self.scrollView.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - UIApplication.shared.statusBarFrame.height - (self.navigationController?.navigationBar.frame.height)! - (self.tabBarController?.tabBar.frame.height)!)
        
        let subViewHeight = self.scrollView.frame.size.height * 1.0

        self.noticeTable.backgroundColor = UIColor.lightGray
        
        subView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: subViewHeight)

        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: subViewHeight)

        collectionView.delegate = self
        collectionView.dataSource = self
    
        scrollView.addSubview(subView)
    }
    
    func loadData() {
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
                        let arrJSON = parseJSON["result"] as! [String: AnyObject]
                        
                        let myProfile = arrJSON["profile"] as! [String: AnyObject]
                        self.nickname = myProfile["nick"] as? String
                        self.gender = myProfile["sex"] as? String
                        self.imageId = arrJSON["image"] as? String
                    } catch {
                        print("catch error")
                    }
                    self.configureTableView()
                    self.configureScrollView()
//                    self.coreData()
                }
            }
        }) .resume()
    }
    
    func coreData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        
        request.entity = entityDescription
        
        do {
            let objects = try Library.LibObject.managedObjectContext.fetch(request)
            
            if objects.count > 0 {
                let match = objects[0] as! Profile
                
                match.nickname = self.nickname
                match.imageid = self.imageId
                match.gender = self.gender
                
                Library.LibObject.imageid = self.imageId!
                Library.LibObject.nickname = self.nickname!
            }
        } catch {
            print("asdfasdf")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == profileTable {
            return 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == profileTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! profileCell
            cell.profileImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/profile/\(Library.LibObject.phoneNumber).jpg"))
            
            cell.profileNickname.text = self.nickname!
            cell.profileImage.layer.masksToBounds = true
            cell.profileImage.layer.cornerRadius = 10
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            cell.textLabel?.text = noticeItem[indexPath.row]
            cell.layer.borderWidth = 0.1
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == profileTable {
            self.profileSegue()
        } else {
            if indexPath.row == 0 {
                self.noticeSegue()
            } else if indexPath.row == 1 {
                self.qnaSegue()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == profileTable {
            return self.profileTable.frame.size.height
        } else {
            return self.noticeTable.frame.size.height / 4
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.buySegue()
        } else if indexPath.row == 1 {
            self.sellSegue()
        } else {
            self.bidSegue()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell1", for: indexPath)
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.3
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell2", for: indexPath)
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.3
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell3", for: indexPath)
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.3
            return cell
        }
    }
    
    func profileSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "profileSegue", sender: self)
        }
    }
    
    func sellSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "sellSegue", sender: self)
        }
    }
    
    func buySegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "buySegue", sender: self)
        }
    }
    
    func bidSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "bidSegue", sender: self)
        }
    }
    
    func noticeSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "noticeSegue", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "profileSegue" {
            let vc = segue.destination as! MyProfileViewController
            vc.imageid = Library.LibObject.phoneNumber + ".jpg"
            vc.nickName = self.nickname!
            vc.gender = self.gender!
        } else if segue.identifier == "bidSegue" {
            let vc = segue.destination as! myBidViewController
//            vc.bidObject = self.myBidObject
        }
    }
 

}
