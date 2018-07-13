//
//  CategoryViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 13..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let category = ["디지털/가전", "스포츠/레저/취미", "키덜트/피규어/소장", "차량/오토바이", "남성의류", "남성패션/잡화", "여성의류", "여성패션/잡화", "뷰티/미용", "유아/출산", "인테리어/가구/장식", "예술/음반", "티켓/상품권/쿠폰", "기타"]
    let categoryImage = ["digital", "game", "sports", "femaleClothes", "femalegoods", "maleClothes", "malegoods", "cars", "digital", "game", "sports", "femaleClothes", "femalegoods", "maleClothes"]
    var categoryType = ""
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()

        // Do any additional setup after loading the view.
        
        selectedTab = self.tabBarItem.tag
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func loadData() {
        let url = URL(string: Library.LibObject.url)
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["category" : ""]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                do {
                    let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                } catch {
                    print("catch")
                }
            }
            
        }) .resume()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryCell
        
        cell.categoryText.text = category[indexPath.row]
        cell.imageView.image = UIImage(named: categoryImage[indexPath.row])
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.3
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 , height: collectionView.frame.size.height / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.categoryType = category[indexPath.item]
        self.selectSegue()
    }
    
    func selectSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "selectSegue", sender: self)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectSegue" {
            let destination = segue.destination as! itemListViewController
            destination.categoryType = self.categoryType
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
