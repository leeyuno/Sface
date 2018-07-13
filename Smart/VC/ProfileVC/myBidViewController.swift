//
//  myBidViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 12..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class myBidViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet var likeTableView: UITableView!
    @IBOutlet var bidTableView: UITableView!
    @IBOutlet weak var subView: UIView!
    
    var productId = ""
    var bidObject = [[AnyObject]]()
    var likeObject = [[AnyObject]]()
    
    var timeLeft: Double!
    
    @IBOutlet weak var menuSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.showBlurLoader()

//        self.configureTableView()
        self.myBidData()
        self.likeData()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "입찰내역"
        
        let slideToRight = UISwipeGestureRecognizer(target: self, action: #selector(slideToBidTableView))
        slideToRight.direction = .right
//        likeTableView.addGestureRecognizer(slideToRight)
//        self.view.addGestureRecognizer(slideToRight)
        
        let slideToLeft = UISwipeGestureRecognizer(target: self, action: #selector(slideToLikeTableView))
        slideToLeft.direction = .left
//        bidTableView.addGestureRecognizer(slideToLeft)
//        self.view.addGestureRecognizer(slideToLeft)
        
        self.subView.addSubview(bidTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch menuSegment.selectedSegmentIndex {
        case 0:
            self.subView.addSubview(bidTableView)
        case 1:
            self.subView.addSubview(likeTableView)
        default:
            break
        }
    }
    
    func bidtouchView() {
        let touchView = Bundle.main.loadNibNamed("touchView", owner: self, options: nil)?[0] as! touchView
        
        touchView.backgroundColor = UIColor.lightGray
        
        touchView.frame = CGRect(x: 0, y: 0, width: self.bidTableView.frame.size.width, height: self.bidTableView.frame.size.height)

        self.bidTableView.addSubview(touchView)
    }
    
    func liketouchView() {
        let touchView = Bundle.main.loadNibNamed("touchView", owner: self, options: nil)?[0] as! touchView
        
        touchView.backgroundColor = UIColor.lightGray
        
        touchView.frame = CGRect(x: 0, y: 0, width: self.likeTableView.frame.size.width, height: self.likeTableView.frame.size.height)
        
        self.likeTableView.addSubview(touchView)
    }
    
    @objc func slideToLikeTableView() {
        self.menuSegment.selectedSegmentIndex = 1
        self.subView.addSubview(likeTableView)
    }
    
    @objc func slideToBidTableView() {
        self.menuSegment.selectedSegmentIndex = 0
        self.subView.addSubview(bidTableView)
    }
    
    func configureTableView() {
        let bidNib = UINib(nibName: "bidView", bundle: nil)
        bidTableView.register(bidNib, forCellReuseIdentifier: "bidViewCell")
        bidTableView.delegate = self
        bidTableView.dataSource = self
        bidTableView.reloadData()
        bidTableView.bounces = false
        bidTableView.backgroundColor = UIColor.lightGray
        bidTableView.separatorStyle = .none
        bidTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: subView.frame.size.height)
        
        if bidObject.count == 0 {
            bidtouchView()
        }
        
        let likeNib = UINib(nibName: "bidView", bundle: nil)
        likeTableView.register(likeNib, forCellReuseIdentifier: "bidViewCell")
        likeTableView.delegate = self
        likeTableView.dataSource = self
        likeTableView.reloadData()
        likeTableView.bounces = false
        likeTableView.backgroundColor = UIColor.lightGray
        likeTableView.separatorStyle = .none
        likeTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: subView.frame.size.height)
        
        if likeObject.count == 0 {
            liketouchView()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.view.removeBlurLoader()
        })
    }
    
    func myBidData() {
        let url = URL(string: Library.LibObject.url + "/mypage/bid")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(Library.LibObject.phoneNumber)", "deviceId" : "\(Library.LibObject.deviceId)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let checkJSON = parseJSON["result"] as? String
                        
                        if checkJSON == nil {
                            let arrJSON = parseJSON["result"] as! NSArray
                            
                            for i in 0 ... arrJSON.count - 1 {

                                let aObject = arrJSON[i] as! NSArray
                                
                                for j in 0 ... aObject.count - 1 {
                                    let bObject = aObject[j] as! [String: AnyObject]
//                                    print(bObject)
                                    let tmpTitle = bObject["title"] as! String
                                    let tmpTag = bObject["tag"] as! NSArray
                                    let tmpImage = bObject["image"] as! NSArray
                                    let tmpBid = bObject["now_Bid"] as! [String: AnyObject]
                                    let tmpTime = bObject["deleted_at"] as! String
                                    let tmpId = bObject["_id"] as! String
                                    
                                    self.bidObject.append([tmpTitle as AnyObject, tmpTime as AnyObject, tmpTag as AnyObject, tmpImage[0] as AnyObject, tmpBid["bid"] as AnyObject, tmpId as AnyObject])
                                    
                                    let date = Date()
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    
                                    let nowDate = formatter.string(from: date)
                                    let nowDate2 = formatter.date(from: nowDate)
                                    let cmpTime = formatter.date(from: tmpTime)
                                    self.timeLeft = cmpTime?.timeIntervalSince(nowDate2!)
                                }
                            }
                        } else {
                            print("데이터가 없다")
                        }
                    } catch {
                        print("loadData catch")
                    }
                    self.configureTableView()
                }
            }
        }) .resume()
    }
    
    func likeData() {
        let url = URL(string: Library.LibObject.url + "/mypage/ho")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(Library.LibObject.phoneNumber)", "deviceId" : "\(Library.LibObject.deviceId)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        do {
                            let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                            
                            let checkJSON = parseJSON["result"] as? String
                            
                            if checkJSON == nil {
                                let arrJSON = parseJSON["result"] as! NSArray
                                for i in 0 ... arrJSON.count - 1 {
                                    let aObject = arrJSON[i] as! NSArray
                                    for j in 0 ... aObject.count - 1 {
                                        let bObject = aObject[i] as! [String: AnyObject]
                                        
                                        let tmpTitle = bObject["title"] as! String
                                        let tmpTag = bObject["tag"] as! NSArray
                                        let tmpImage = bObject["image"] as! NSArray
                                        let tmpBid = bObject["now_Bid"] as! [String: AnyObject]
                                        let tmpTime = bObject["deleted_at"] as! String
                                        let tmpId = bObject["_id"] as! String
                                        
                                        self.likeObject.append([tmpTitle as AnyObject, tmpTime as AnyObject, tmpTag as AnyObject, tmpImage[0] as AnyObject, tmpBid["bid"] as AnyObject, tmpId as AnyObject])
                                    }
                                }
                            }
                            self.configureTableView()
                        } catch {
                            print("catch")
                        }
                    }
                } else if httpResponse.statusCode == 500 {
                    DispatchQueue.main.async {
                        self.configureTableView()
                        
                        let textLabel = UILabel()
                        textLabel.frame.size = CGSize(width: 200, height: 30)
                        textLabel.textAlignment = .center
                        textLabel.text = "데이터가 없습니다."
                        textLabel.sizeToFit()
                        textLabel.center = self.bidTableView.center
                        //                            textLabel.center.x = self.view.center.x
                        //                            textLabel.center.y = self.bidTableView.center.y
                        
                        let textLabel2 = UILabel()
                        textLabel2.frame.size = CGSize(width: 200, height: 30)
                        textLabel2.textAlignment = .center
                        textLabel2.text = "데이터가 없습니다."
                        textLabel2.sizeToFit()
                        textLabel2.center = self.likeTableView.center
                        //                            textLabel2.center.x = self.view.center.x
                        //                            textLabel2.center.y = self.likeTableView.center.y

//                        self.bidtouchView()
//                        self.liketouchView()
//                        self.bidTableView.addSubview(textLabel)
//                        self.likeTableView.addSubview(textLabel2)
                    }
                }
            }
        }) .resume()
    }
    
    func numberWithComma(_ number: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: number)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bidTableView {
            return self.bidObject.count
        } else {
            return self.likeObject.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == bidTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bidViewCell", for: indexPath) as! bidView
            
            cell.itemName.text = bidObject[indexPath.row][0] as! String
            cell.nowPrice.text = self.numberWithComma(bidObject[indexPath.row][4] as! NSNumber) + "원"
            cell.productId = bidObject[indexPath.row][5] as! String
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            print("입찰목록 \(timeLeft)")
            if timeLeft! < 0 {
                cell.leftTime.text = "판매종료"
            } else {
                cell.leftTime.text = self.convertTime(timeLeft)
            }
            cell.time = timeLeft
            
            cell.bidImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/product/\(bidObject[indexPath.row][3] as! String)"))
            
            cell.backgroundColor = UIColor.lightGray
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 5, y: 5, width: self.view.frame.size.width - 10, height: 145))
            
            whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
//            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 2.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.2
            
            whiteRoundedView.layer.masksToBounds = true
            whiteRoundedView.layer.cornerRadius = 5
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubview(toBack: whiteRoundedView)
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bidViewCell", for: indexPath) as! bidView
            
            cell.itemName.text = likeObject[indexPath.row][0] as! String
            cell.nowPrice.text = self.numberWithComma(likeObject[indexPath.row][4] as! NSNumber) + "원"
            cell.productId = likeObject[indexPath.row][5] as! String
            print("찜목록 \(timeLeft)")
            if timeLeft! > 0 {
                cell.leftTime.text = "판매종료"
            } else {
                cell.leftTime.text = self.convertTime(timeLeft)
            }
            
            cell.time = timeLeft
            
            cell.bidImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/product/\(likeObject[indexPath.row][3] as! String)"))
            
            cell.backgroundColor = UIColor.lightGray
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 5, y: 4, width: self.view.frame.size.width - 10, height: 140))
            
            whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
//            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 2.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.2
            
            whiteRoundedView.layer.masksToBounds = true
            whiteRoundedView.layer.cornerRadius = 5
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubview(toBack: whiteRoundedView)
            
            cell.selectionStyle = .none

            return cell
        }
    }
    
    func convertTime(_ time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == bidTableView {
            self.productId = bidObject[indexPath.row][5] as! String
        } else if tableView == likeTableView {
            self.productId = likeObject[indexPath.row][5] as! String
        }
        
        self.productSegue()
    }
    
    func productSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "productSegue", sender: self)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "productSegue" {
            let vc = segue.destination as! ProductViewController
            vc.productId = self.productId
        }
    }
 

}
