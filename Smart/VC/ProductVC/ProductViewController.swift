//
//  ProductViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 13..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, replyCellDelegate, productSettingDelegate {
    func replyReply(_ replyKey: String, _ replyId: String) {
        self.replyId = replyId
        self.replyKey = replyKey
        self.replyReplySegue()
    }
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var subView: UIView!
    @IBOutlet weak var imageScroll: UIScrollView!
    @IBOutlet weak var replyTable: UITableView!
    @IBOutlet var contentsTextView: UITextView!
    var replyId = ""
    var replyKey = ""
    var replyCount: Int!
    
    var productId = ""
    
    var imageArray = [String]()
    
    //입찰 남은 횟수
    @IBOutlet weak var counter: UILabel!
    
    var itemObject = [[AnyObject]]()
    
    var textViewHeight = 0
    
    var productName = ""
    var contentsText = ""
    
    var startPrice = ""
    var nowPrice = ""
    var endPrice = ""
    
    var tagObject = [AnyObject]()
    
    //댓글 데이터배열
    var replyObject = [[AnyObject]]()
    
    @IBOutlet weak var likeView: UIView!

    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.configureScrollView()
        self.view.showBlurLoader()
        
        self.loadData()
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeFunc))
        likeView.isUserInteractionEnabled = true
        likeView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likeView.layer.masksToBounds = true
        likeView.layer.borderColor = UIColor.black.cgColor
        likeView.layer.borderWidth = 0.3
        likeView.layer.cornerRadius = 10
        
        bidBUtton.layer.masksToBounds = true
        bidBUtton.layer.borderColor = UIColor.black.cgColor
        bidBUtton.layer.borderWidth = 0.4
        bidBUtton.layer.cornerRadius = 10
//        bidBUtton.backgroundColor = UIColor.lightGray
        
        counter.layer.masksToBounds = true
        counter.layer.cornerRadius = counter.frame.size.height / 2
        counter.layer.borderWidth = 0.2
        counter.layer.borderColor = UIColor.black.cgColor
        
        bottomView.layer.borderWidth = 0.3
        bottomView.layer.borderColor = UIColor.black.cgColor
        
//        numberOfReply.text = "댓글 \(replyObject.count)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        
    }
    
    func configureScrollView() {
        scrollView.bounces = false
        scrollView.delegate = self
//        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + CGFloat(replyCount) * 70)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.imageScroll.frame.size.height + self.replyTable.frame.size.height)
        
        scrollView.addSubview(subView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.view.removeBlurLoader()
        })
    }
    
    func configureTableView() {
        //댓글셀
        let nib = UINib(nibName: "replyCell", bundle: nil)
        replyTable.register(nib, forCellReuseIdentifier: "replyCell")
        
        //댓글, 댓글쓰기 버튼 셀
        let nib2 = UINib(nibName: "productSettingCell", bundle: nil)
        replyTable.register(nib2, forCellReuseIdentifier: "productSettingCell")
        
        //텍스트뷰 셀
        let nib3 = UINib(nibName: "textViewCell", bundle: nil)
        replyTable.register(nib3, forCellReuseIdentifier: "textViewCell")
        
        //제품이름, 가격 셀
        let nib4 = UINib(nibName: "priceCell", bundle: nil)
        replyTable.register(nib4, forCellReuseIdentifier: "priceCell")
        
        let nib5 = UINib(nibName: "tagCell", bundle: nil)
        replyTable.register(nib5, forCellReuseIdentifier: "tagCell")
        
        replyTable.delegate = self
        replyTable.dataSource = self
        replyTable.bounces = false
        replyTable.isScrollEnabled = false
        replyTable.layer.masksToBounds = true
        replyTable.layer.borderColor = UIColor.lightGray.cgColor
        replyTable.layer.borderWidth = 0.3
        
        let replyTableHeight = 150 + 50 + 45 + (textViewHeight * 14 + 20) + (70 * (replyObject.count))
        
        replyTable.frame.size = CGSize(width: self.view.frame.size.width, height: CGFloat(replyTableHeight))

        replyTable.reloadData()
        
        self.configureScrollView()
//        numberOfReply.text = "댓글 \(replyObject.count)"
    }
    
    func configureImageView() {
        imageScroll.delegate = self
        imageScroll.bounces = false
        imageScroll.isPagingEnabled = true
        
        pageControl.numberOfPages = self.imageArray.count
        
        imageScroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(self.imageArray.count), height: self.imageScroll.frame.size.height)
        
        for i in 0 ... self.imageArray.count - 1 {
            let productImageView = Bundle.main.loadNibNamed("productImageView", owner: self, options: nil)?[0] as! productImageView
            productImageView.frame = CGRect(x: CGFloat(i) * self.imageScroll.frame.size.width, y: self.imageScroll.frame.origin.y, width: self.view.frame.size.width, height: self.imageScroll.frame.size.height)

            productImageView.productImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/product/\(self.imageArray[i])"))
            
//            productImageView.backgroundColor = UIColor.lightGray
//            productImageView.productImage.layer.masksToBounds = true
//            productImageView.productImage.layer.borderColor = UIColor.lightGray.cgColor
//            productImageView.productImage.layer.borderWidth = 0.3
//            productImageView.productImage.layer.cornerRadius = 10
            
            imageScroll.addSubview(productImageView)
        }
    }
    
    func loadData() {
        let url = URL(string: Library.LibObject.url + "/hotproduct/click")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["_id" : "\(self.productId)"]
        print(json)
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
                        print(arrJSON)
                        self.productName = arrJSON["title"] as! String
                        self.contentsText = arrJSON["text"] as! String
                        self.contentsTextView.text = arrJSON["text"] as! String
                        
                        self.textViewHeight = self.contentsTextView.numberOfLines()
                        

                        self.startPrice = self.numberWithComma(arrJSON["start_Bid"] as! NSNumber)
                        self.endPrice = self.numberWithComma(arrJSON["final_Bid"] as! NSNumber)
                        
                        if arrJSON["now_Bid"] as? [String: AnyObject] != nil {
                            let priceJSON = arrJSON["now_Bid"] as! [String: AnyObject]
                            self.nowPrice = self.numberWithComma(priceJSON["bid"] as! NSNumber)
                            
                        } else {
                            self.nowPrice = self.numberWithComma(arrJSON["start_Bid"] as! NSNumber)
                        }
                        
                        let replyArray = arrJSON["reply"] as! NSArray
                        
                        if replyArray.count > 0 {
                            for i in 0 ... replyArray.count - 1 {
                                let replyItem = replyArray[i] as! [String: AnyObject]
                                self.replyObject.append([replyItem["_id"] as AnyObject, replyItem["id"] as AnyObject, replyItem["key"] as AnyObject, replyItem["nick"] as AnyObject, replyItem["text"] as AnyObject])
                            }
                        }
                        
                        let tagArray = arrJSON["tag"] as! NSArray
                        if tagArray.count > 0 {
                            for i in 0 ... tagArray.count - 1 {
                                self.tagObject.append(tagArray[i] as AnyObject)
                            }
                        }
                        
                        self.imageArray = arrJSON["image"] as! [String]
                        self.counter.text = String(arrJSON["counter_Bid"] as! Int)
                
                        let gap = self.numberWithComma(arrJSON["gapTouch"] as! NSNumber)
                        
                        self.bidBUtton.setTitle("입찰(+\(gap))", for: .normal)
                        
                        self.configureImageView()
                        self.configureTableView()
                    } catch {
                        print("catch error")
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
    
    @IBOutlet weak var bidBUtton: UIButton!
    @IBAction func bidButton(_ sender: Any) {
        
        if self.counter.text == "0" {
            let alert = UIAlertController(title: "입찰횟수 부족", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            self.alertBid()
        }
    }
    
    func alertBid() {
        let alert = UIAlertController(title: "입찰 하시겠습니까?", message: "되돌릴 수 없습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: { Void in
            self.bid()
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadCost() {
        let url = URL(string: Library.LibObject.url + "/hotproduct/click")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["_id" : "\(self.productId)"]
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
                        
                        self.counter.text = String(arrJSON["counter_Bid"] as! Int)
                        
                        if arrJSON["now_Bid"] as? [String: AnyObject] != nil {
                            let priceJSON = arrJSON["now_Bid"] as! [String: AnyObject]
                            let tmpNowPrice = self.numberWithComma(priceJSON["bid"] as! NSNumber)
                            
                        } else {
                            print("nil")
                        }
                    } catch {
                        print("catch error")
                    }
                }
            }
        }) .resume()
    }
    
    func bid() {
        let url = URL(string: Library.LibObject.url + "/bid")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(Library.LibObject.phoneNumber)", "product_id" : "\(self.productId)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    self.reloadCost()
                } else if httpResponse.statusCode == 500 {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "입찰횟수 부족", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }) .resume()
    }
    
    @objc func likeFunc() {
        print("likeFunc")
        
        if likeImage.image == UIImage(named: "star1") {
            likeImage.image = UIImage(named: "star2")
        } else {
            likeImage.image = UIImage(named: "star1")
        }
        
        let url = URL(string: Library.LibObject.url + "/heart")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(Library.LibObject.phoneNumber)", "product_id" : "\(productId)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                //이미 좋아요한 제품인지 아닌지 판단
                if httpResponse.statusCode == 200 {
                    
                }
            }
        }) .resume()
    }
    
    func isAlreadyLike() {
        if likeImage.image == UIImage(named: "star1") {
            likeImage.image = UIImage(named: "star2")
        } else {
            likeImage.image = UIImage(named: "star1")
        }
    }
    
    func replySegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "replySegue", sender: self)
        }
    }
    
    func replyReplySegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "replyReplySegue", sender: self)
        }
    }
    
    @IBAction func reply(_ sender: Any) {
        self.replySegue()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyObject.count + 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! priceCell

            cell.productName.text = self.productName
            cell.startPrice.text = self.startPrice
            cell.endPrice.text = self.endPrice
            cell.nowPrice.text = self.nowPrice
            
            cell.setSelected(true, animated: true)
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textViewCell", for: indexPath) as! textViewCell
            
            cell.textView.text = self.contentsText
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! tagCell
            
            for i in 0 ... self.tagObject.count - 1 {
                if i == 0 {
                    cell.tag1.text = "#\(self.tagObject[i] as! String)"
                    cell.tag2.text = ""
                    cell.tag3.text = ""
                } else if i == 2 {
                    cell.tag2.text = "#\(self.tagObject[i] as! String)"
                    cell.tag3.text = ""
                } else if i == 3 {
                    cell.tag3.text = "#\(self.tagObject[i] as! String)"
                }
            }
//            cell.tag1.text = self.tagObject[0] as! String
//            cell.tag2.text = self.tagObject[1] as! String
//            cell.tag3.text = self.tagObject[2] as! String
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productSettingCell", for: indexPath) as! productSettingCell
            
            cell.numberOfReply.text = "댓글 \(self.replyObject.count)"
            
            cell.productSettingDelegate = self
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! replyCell
            cell.selectionStyle = .none
            
            if replyObject[indexPath.row - 4][2] as? String != nil {
                cell.backgroundColor = UIColor.lightGray
                cell.replyButton.isHidden = true
            } else {
                
            }
            
            cell.replyId = replyObject[indexPath.row - 4][0] as! String
            
            if replyObject[indexPath.row - 4][2] as? String != nil {
                cell.replyKey = replyObject[indexPath.row - 4][2] as! String
            }
            
            cell.nickname.text = self.replyObject[indexPath.row - 4][3] as? String
            cell.profileImage.kf.setImage(with: URL(string: Library.LibObject.url + "/download/profile/\(replyObject[indexPath.row - 4][1]).jpg"))
            cell.contents.text = self.replyObject[indexPath.row - 4][4] as? String
            
            cell.replyCellDelegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else if indexPath.row == 1 {
            return CGFloat(textViewHeight) * 14 + 20
        } else if indexPath.row == 2 {
            return 45.0
        } else if indexPath.row == 3 {
            return 50.0
        } else {
            return 70.0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = floor(imageScroll.contentOffset.x / imageScroll.frame.size.width)
        
        pageControl.currentPage = Int(currentPage)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "replySegue" {
            let vc = segue.destination as! ReplyViewController
            vc.replyObject = self.replyObject
            vc.productId = self.productId
        } else if segue.identifier == "replyReplySegue" {
            let vc = segue.destination as! replyReplyViewController
            vc.replyObject = self.replyObject
            vc.replyId = self.replyId
            vc.replyKey = self.replyKey
            vc.productId = self.productId
        }
        
    }
 

}
