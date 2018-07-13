//
//  HotItemViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 12..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData

class HotItemViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hotTableView: UITableView!
    
    var gender = ""
    
    var itemObject = [[AnyObject]]()
    
    var leftTime: Double!
    
    var hotView: HotView!
    var productId = ""
    var replyCount: Int!
    
    var loading = UIActivityIndicatorView()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.showActivityIndicator()
        self.view.showBlurLoader()
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription

        do {
            let objects = try Library.LibObject.managedObjectContext.fetch(request)
            if objects.count > 0 {
                let match = objects[0] as! Profile
                gender = match.value(forKey: "gender") as! String
            }

        } catch {
            print("coredata")
        }
        
        self.loadData()
        
//        self.configureScrollView()
        selectedTab = self.tabBarItem.tag
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.3
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.hotTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: Any) {
        loadData()
        refreshControl.endRefreshing()
    }
    
    func touchView() {
        let touchView = Bundle.main.loadNibNamed("touchView", owner: self, options: nil)?[0] as! touchView
        
        let height = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
        
        touchView.backgroundColor = UIColor.lightGray
        touchView.frame = CGRect(x: 0, y: height, width: self.view.frame.size.width, height: self.view.frame.size.height - height - (self.tabBarController?.tabBar.frame.height)!)
        
        self.view.addSubview(touchView)
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "hotCell", bundle: nil)
        hotTableView.register(nib, forCellReuseIdentifier: "hotCell")
        hotTableView.delegate = self
        hotTableView.dataSource = self
        
//        hotTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.hotTableView.frame.size.height)
        
        hotTableView.reloadData()
        self.view.removeBlurLoader()
    }
    
    func createHotView() {
        scrollView.delegate = self
        
        scrollView.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - UIApplication.shared.statusBarFrame.height - (self.navigationController?.navigationBar.frame.height)! - (tabBarController?.tabBar.frame.height)!)
        
        scrollView.backgroundColor = UIColor.lightGray

        for i in 0 ... self.itemObject.count - 1 {
            hotView = Bundle.main.loadNibNamed("HotView", owner: self, options: nil)?[0] as! HotView
            
            let hotHeight = self.scrollView.frame.size.height / 2
            scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: hotHeight * CGFloat(self.itemObject.count))
            hotView.frame = CGRect(x: self.scrollView.frame.origin.x, y: CGFloat(i) * hotHeight, width: self.scrollView.frame.size.width, height: hotHeight)
            
//            hotView.tagNumber = i
            hotView.tag = i
            let aObject = self.itemObject[i] as NSArray
            
            //제품정보
            hotView.id = aObject[0] as! String
            
            //가격정보
            let priceObject = aObject[1] as? [String: AnyObject]
            
            if priceObject != nil {
                self.hotView.nowPrice.text = String(self.numberWithComma(priceObject!["bid"] as! NSNumber))
//                let tmpPrice = String(priceObject?["bid"] as! Int)
            } else {
//                let tmpPrice = self.numberWithComma(aObject[4] as! NSNumber)
                self.hotView.nowPrice.text = String(self.numberWithComma(aObject[4] as! NSNumber))
//                let tmpPrice = String(aObject[4] as! Int)
            }

            //이미지정보
            let imageObject = aObject[2] as! NSArray
            if imageObject.count > 0 {
                hotView.productImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/product/\(imageObject[0])"))
            }
            
            //시간정보
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let nowDate = formatter.string(from: date)
            let nowDate2 = formatter.date(from: nowDate)
            let cmpTime = formatter.date(from: aObject[3] as! String)
            let compareTime = cmpTime?.timeIntervalSince(nowDate2!)
            
            hotView.time = compareTime
//            hotView.hotViewDelegate = self
            hotView.layer.masksToBounds = true
            hotView.layer.cornerRadius = 5
            hotView.layer.borderWidth = 0.3
            hotView.layer.borderColor = UIColor.lightGray.cgColor
            
            self.scrollView.addSubview(hotView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                self.view.removeBlurLoader()
            })
        }
    }
    
    func nothingItem() {
        print("nothing")
        
        self.touchView()
//        let alert = UIAlertController(title: "핫아이템이 존재하지 않습니다.", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
    }
    
    func numberWithComma(_ number: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: number)!
    }

    func loadData() {
        self.itemObject.removeAll()
        let url = URL(string: Library.LibObject.url + "/hotproduct/view")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["sex" : "\(self.gender)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
                if (error?.localizedDescription)! == "The request timed out." {
                    print("핫아이템 데이터 없음")
                    DispatchQueue.main.async {
                        self.nothingItem()
                        self.view.removeBlurLoader()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        let arrJSON = parseJSON["result"] as! NSArray
                        print(arrJSON)
                        for i in 0 ... arrJSON.count - 1 {
                            let aObject = arrJSON[i] as! NSArray
                            
                            for j in 0 ... aObject.count - 1 {
                                let bObject = aObject[j] as! [String: AnyObject]
                                
                                //status 값이 1인경우만 값을 배열에 넣은 후 출력 아닌경우 -> 판매종료된 물품 배열에 넣지 않음
                                if bObject["status"] as! Int == 1 {
                                    let replyObject = bObject["reply"] as! NSArray
                                    
                                    let date = Date()
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    
                                    let nowDate = formatter.string(from: date)
                                    let nowDate2 = formatter.date(from: nowDate)
                                    let cmpTime = formatter.date(from: bObject["deleted_at"] as! String)
                                    let timeLeft = (cmpTime?.timeIntervalSince(nowDate2!))!
                                    
                                    //입찰 상태인지 아닌지 체크후 입찰상태면 입찰가격, 아니면 최저가를 출력
                                    let bidCheck = bObject["now_Bid"] as? String
                                    
                                    var nowBid = 0
                                    
                                    if bidCheck == nil {
                                        nowBid = bObject["start_Bid"] as! Int
                                    } else {
                                        let tmpPrice = bObject["now_Bid"] as! [String: AnyObject]
                                        print(bidCheck)
                                        nowBid = tmpPrice["bid"] as! Int
                                        
                                    }
                                    
                                    //이미지 배열중 첫번째를 메인 이미지로 설정
                                    let mainImage = bObject["image"] as! NSArray
                                    
                                    self.itemObject.append([bObject["_id"] as AnyObject, nowBid as AnyObject, mainImage[0] as AnyObject, bObject["deleted_at"] as AnyObject, bObject["start_Bid"] as AnyObject, replyObject.count as AnyObject, timeLeft as AnyObject])
//                                    print(self.itemObject)
                                } else {
//                                    print("판매종료물품")
                                }
                            }
                        }
                        self.configureTableView()
                    } catch {
                        print("loadData catch")
                    }
//                    self.createHotView()
                }
            }
        }) .resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemObject.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.productId = self.itemObject[indexPath.row][0] as! String
        self.replyCount = self.itemObject[indexPath.row][5] as! Int
        
        self.productSegue()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotCell", for: indexPath) as! hotCell
        cell.hotImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/product/\(itemObject[indexPath.row][2])"))
        cell.hotPrice.text = String(self.numberWithComma(itemObject[indexPath.row][1] as! NSNumber))

        cell.hotTime.text = self.convertTime(itemObject[indexPath.row][6] as! Double)
        
        cell.time = itemObject[indexPath.row][6] as! Double

        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.selectionStyle = .none
        
        return cell
    }
    
    func productSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "productSegue", sender: self)
        }
    }
    
    func convertTime(_ time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productSegue" {
            let vc = segue.destination as! ProductViewController
            vc.productId = self.productId
            vc.replyCount = self.replyCount
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
