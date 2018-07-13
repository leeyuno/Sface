//
//  itemListViewController.swift
//  Smart
//
//  Created by leeyuno on 2017. 12. 12..
//  Copyright © 2017년 com.SFACE. All rights reserved.
//

import UIKit

class itemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    var categoryType = ""
    var productId = ""
    @IBOutlet weak var tableView: UITableView!
    
    var productArray = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
//        self.configureTableView()
        // Do any additional setup after loading the view.
        selectedTab = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "itemView", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "itemViewCell")
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadData() {
        let url = URL(string: Library.LibObject.url + "/category")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["category" : "\(categoryType)"]
        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                print(response!)
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        print(parseJSON)
                        let checkJSON = parseJSON["result"] as? String
                        print(checkJSON!)
                    } catch {
                        print("loadData catch")
                    }
                    self.configureTableView()
                }
            }
        }) .resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemViewCell", for: indexPath) as! itemView
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
