//
//  QnAViewController.swift
//  Smart
//
//  Created by leeyuno on 2018. 1. 24..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit
import MessageUI

class QnAViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        let nib1 = UINib(nibName: "qnaCell", bundle: nil)
        let nib2 = UINib(nibName: "faqCell", bundle: nil)
        
        tableView.register(nib1, forCellReuseIdentifier: "qnaCell")
        tableView.register(nib2, forCellReuseIdentifier: "faqCell")
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func emailTapped() {
        print("tapped")
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sface.uno@gmail.com"])
//            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("취소")
        case .saved:
            print("임시저장")
        case .sent:
            print("전송완료")
        default:
            print("전송실패")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100.0
        } else {
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "자주하는질문"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "qnaCell", for: indexPath) as! qnaCell
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
            
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(tap)
            
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 3.0

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath) as! faqCell
            
            return cell
        }
        
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "qnaCell", for: indexPath) as! qnaCell
//
//            let tap = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
//
//            cell.isUserInteractionEnabled = true
//            cell.addGestureRecognizer(tap)
//
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath) as! faqCell
//
//            return cell
//        }
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
