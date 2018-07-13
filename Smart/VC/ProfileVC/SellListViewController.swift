//
//  SellListViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 14..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class SellListViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuSegment: UISegmentedControl!
    
    @IBOutlet weak var sellTableView: UITableView!
    @IBOutlet weak var soldTableView: UITableView!
    
    @IBOutlet weak var mainView: UIView!
    
    var sellObject = [[AnyObject]]()
    var soldObject = [[AnyObject]]()
    
    var productId = ""
    
    var timeLeft: Double!
    var selltimeArray = [Double]()
    var soldtimeArray = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.showBlurLoader()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "판매내역"
        
        menuSegment.layer.masksToBounds = true
        menuSegment.layer.cornerRadius = 0
        menuSegment.frame.size.height = 40
        
        self.loadData()
        
        let slideRight = UISwipeGestureRecognizer(target: self, action: #selector(slideToSellView))
        slideRight.direction = .right
//        soldTableView.addGestureRecognizer(slideRight)
//        self.view.addGestureRecognizer(slideRight)
        
        let slideLeft = UISwipeGestureRecognizer(target: self, action: #selector(slideToSoldView))
        slideLeft.direction = .left
//        sellTableView.addGestureRecognizer(slideLeft)
//        self.view.addGestureRecognizer(slideLeft)
        
        self.mainView.addSubview(sellTableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainView.addSubview(sellTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sellTouchView() {
        let touchView = Bundle.main.loadNibNamed("touchView", owner: self, options: nil)?[0] as! touchView
        
        touchView.backgroundColor = UIColor.lightGray
        touchView.frame = CGRect(x: 0, y: 0, width: self.sellTableView.frame.size.width, height: self.sellTableView.frame.size.height)
        
        self.sellTableView.addSubview(touchView)
    }
    
    func soldTouchView() {
        let touchView = Bundle.main.loadNibNamed("touchView", owner: self, options: nil)?[0] as! touchView
        
        touchView.backgroundColor = UIColor.lightGray
        touchView.frame = CGRect(x: 0, y: 0, width: self.soldTableView.frame.size.width, height: self.soldTableView.frame.size.height)
        
        self.soldTableView.addSubview(touchView)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch menuSegment.selectedSegmentIndex {
        case 0:
            self.mainView.addSubview(sellTableView)
        case 1:
            self.mainView.addSubview(soldTableView)
        default:
            break
        }
    }
    
    @objc func slideToSoldView() {
        self.menuSegment.selectedSegmentIndex = 1
        self.mainView.addSubview(soldTableView)
    }
    
    @objc func slideToSellView() {
        self.menuSegment.selectedSegmentIndex = 0
        self.mainView.addSubview(sellTableView)
    }
    
    func configureTableView() {
        let sellnib = UINib(nibName: "sellCell", bundle: nil)
        sellTableView.register(sellnib, forCellReuseIdentifier: "sellCell")
        sellTableView.delegate = self
        sellTableView.dataSource = self
        sellTableView.bounces = false
        sellTableView.separatorStyle = .none
        sellTableView.backgroundColor = UIColor.lightGray
        sellTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: mainView.frame.size.height)
        
        if sellObject.count == 0 {
            self.sellTouchView()
        }
        
        let soldnib = UINib(nibName: "soldCell", bundle: nil)
        soldTableView.register(soldnib, forCellReuseIdentifier: "soldCell")
        soldTableView.delegate = self
        soldTableView.dataSource = self
        soldTableView.separatorStyle = .none
        soldTableView.backgroundColor = UIColor.lightGray
        soldTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: mainView.frame.size.height)
        
        if soldObject.count == 0 {
            self.soldTouchView()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute:  {
            self.view.removeBlurLoader()
        })
    }
    
    func loadData() {
        let url = URL(string: Library.LibObject.url + "/mypage/sell")
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
//                print(httpResponse.statusCode)
                
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
                                        let bObject = aObject[j] as! [String: AnyObject]
                                        
                                        let tmpCheck = bObject["status"] as! Int
                                        
                                        if tmpCheck == 1 {
                                            let tmpTitle = bObject["title"] as! String
                                            let tmpId = bObject["_id"] as! String
                                            let tmpTime = bObject["deleted_at"] as! String
                                            
                                            let tmpImage = bObject["image"] as! NSArray

                                            let tmpBidCheck = bObject["now_Bid"] as? String
                                            
                                            if tmpBidCheck == nil {
                                                let tmpPrice = bObject["start_Bid"] as! Int
                                                self.sellObject.append([tmpTitle as AnyObject, tmpId as AnyObject, tmpTime as AnyObject, tmpImage[0] as AnyObject, tmpPrice as AnyObject])
                                            } else {
                                                let tmpPrice = bObject["now_Bid"] as! [String: AnyObject]
                                                self.sellObject.append([tmpTitle as AnyObject, tmpId as AnyObject, tmpTime as AnyObject, tmpImage[0] as AnyObject, tmpPrice["bid"] as AnyObject])
                                            }
                                            
                                            let date = Date()
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                            
                                            let nowDate = formatter.string(from: date)
                                            let nowDate2 = formatter.date(from: nowDate)
                                            let cmpTime = formatter.date(from: tmpTime)
                                            self.timeLeft = cmpTime?.timeIntervalSince(nowDate2!)
                                            self.selltimeArray.append((cmpTime?.timeIntervalSince(nowDate2!))!)
                                        } else {
                                            let tmpTitle = bObject["title"] as! String
                                            let tmpId = bObject["_id"] as! String
                                            let tmpTime = bObject["deleted_at"] as! String
                                            let tmpImage = bObject["image"] as! NSArray
                                            let tmpBidCheck = bObject["now_Bid"] as? String
                                            
                                            //formatter로 string -> date 로 포멧변경
                                            //formatter2로 date값을 yyyy-MM-dd 포멧으로 변경
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                            let endDate = formatter.date(from: tmpTime)
//                                            let endDate2 = formatter.string(from: endDate)
                                            
                                            let formatter2 = DateFormatter()
                                            formatter2.dateFormat = "yyyy.MM.dd"
                                            let endDate2 = formatter2.string(from: endDate!)

                                            if tmpBidCheck == nil {
                                                let tmpPrice = bObject["start_Bid"] as! Int
                                                self.soldObject.append([tmpTitle as AnyObject, tmpId as AnyObject, endDate2 as AnyObject, tmpImage[0] as AnyObject, tmpPrice as AnyObject])
                                            } else {
                                                let tmpPrice = bObject["now_Bid"] as! [String: AnyObject]
                                                self.soldObject.append([tmpTitle as AnyObject, tmpId as AnyObject, endDate2 as AnyObject, tmpImage[0] as AnyObject, tmpPrice["bid"] as AnyObject])
                                            }
                                        }
                                    }
                                }
                            }
//                            print(self.timeArray)
                        } catch {
                            print("catch")
                        }
                        self.configureTableView()
                    }
                } else if httpResponse.statusCode == 500 {
                    DispatchQueue.main.async {
                        self.configureTableView()
                        
                        let textLabel = UILabel()
                        textLabel.frame.size = CGSize(width: 200, height: 30)
                        textLabel.textAlignment = .center
                        textLabel.text = "데이터가 없습니다."
                        textLabel.sizeToFit()
                        textLabel.center.x = self.view.center.x
                        textLabel.center.y = self.sellTableView.center.y
                        
                        let textLabel2 = UILabel()
                        textLabel2.frame.size = CGSize(width: 200, height: 30)
                        textLabel2.textAlignment = .center
                        textLabel2.text = "데이터가 없습니다."
                        textLabel2.sizeToFit()
                        textLabel2.center.x = self.view.center.x
                        textLabel2.center.y = self.soldTableView.center.y
//                        self.sellTableView.backgroundColor = UIColor.white
//                        self.soldTableView.backgroundColor = UIColor.white
                        self.sellTableView.addSubview(textLabel)
                        self.soldTableView.addSubview(textLabel2)
                    }
                }
            }
            
        }) .resume()
    }
    
    func convertTime(_ time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
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
        if tableView == sellTableView {
            return sellObject.count
        } else {
            return soldObject.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sellTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sellCell", for: indexPath) as! sellCell

            cell.productId = self.sellObject[indexPath.row][1] as! String
            cell.productImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/product/\(sellObject[indexPath.row][3] as! String)"))
            
            cell.productName.text = self.sellObject[indexPath.row][0] as! String
            cell.nowPrice.text = self.numberWithComma(self.sellObject[indexPath.row][4] as! NSNumber) + "원"

            if selltimeArray[indexPath.row] < 0 {
                cell.leftTime.text = "판매종료"
            } else {
                cell.leftTime.text = self.convertTime(selltimeArray[indexPath.row])
            }
            
            cell.time = selltimeArray[indexPath.row]
            
            cell.backgroundColor = UIColor.lightGray
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 5, y: 5, width: self.view.frame.size.width - 10, height: 145))
            
//            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 2.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.2
            
            whiteRoundedView.layer.masksToBounds = true
            whiteRoundedView.layer.cornerRadius = 5
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubview(toBack: whiteRoundedView)
            
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "soldCell", for: indexPath) as! soldCell
            
            cell.backgroundColor = UIColor.lightGray

            cell.productId = self.soldObject[indexPath.row][1] as! String
            cell.productName.text = self.soldObject[indexPath.row][0] as? String
            cell.productImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/product/\(soldObject[indexPath.row][3] as! String)"))
            cell.productPrice.text = self.numberWithComma(self.soldObject[indexPath.row][4] as! NSNumber) + "원"
            
            cell.productDate.text = self.soldObject[indexPath.row][2] as! String
            
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
            cell.separatorInset = .zero
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sellTableView {
            self.productId = sellObject[indexPath.row][1] as! String
        } else {
            self.productId = soldObject[indexPath.row][1] as! String
        }
        self.selectSegue()
    }
    
    func selectSegue() {
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
