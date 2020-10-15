//
//  AddViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/09/30.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    let dataRecord = DataRecordModel()
    
    var projectArray = [ProjectDataModel]()
    
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var orderDate: UIDatePicker!
    
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var orderAmountButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        
        addProjectButton.layer.cornerRadius = addProjectButton.frame.size.height / 4
        
        orderAmountButton.layer.cornerRadius = orderAmountButton.frame.size.height / 4
        
        finishButton.layer.cornerRadius = finishButton.frame.size.height / 4
        
        self.orderDate.setValue(UIColor.darkGray, forKeyPath: "textColor")
        self.orderDate.setValue(false, forKey: "highlightsToday")

        
        if let data = dataRecord.loadItems() {
            projectArray = data
        }
    }
    
    @IBAction func projectButtonPressed(_ sender: UIButton) {
        addInfo(name: "案件名入力", label: projectName)
        
    }
    @IBAction func orderAmountButtonPressed(_ sender: UIButton) {
        addInfo(name: "受注額入力", label: orderAmount)
    }
    
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        if let project = projectName.text {
            if project == "" || project == "案件名" {
                alertForEmptyProjectName()
            } else {
                if let order = orderAmount.text {
                    if order == "" || order == "受注額" {
                        alertForEmptyOrderAmount()
                    } else {
                        let date = orderDate.date.timeIntervalSince1970
                        let data = ProjectDataModel(projectName: project, orderAmount: order, orderDate: date)
                        projectArray.append(data)
                        dataRecord.saveItems(projectArray: projectArray)
                        
                        closeAndFinsh()
                    }
                }
            }
        }
    }
    
    
    func closeAndFinsh() {
        let alert = UIAlertController(title: "入力完了しました", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.performSegue(withIdentifier: "BackToHome", sender: self)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func addInfo(name: String, label: UILabel) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "\(name)", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "入力", style: .default) { (action) in
            label.text = textFiled.text!
            label.textColor = UIColor.darkGray
        }
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        alert.addTextField { (alertTextFiled) in
            switch name {
            case "案件名入力":
                alertTextFiled.placeholder = "株式会社おちつき"
            case "受注額入力":
                alertTextFiled.placeholder = "50000円"
            default:
                alertTextFiled.placeholder = "..."
            }
                
            
            textFiled = alertTextFiled
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertForEmptyProjectName() {
        
        let alert = UIAlertController(title: "案件名が空欄です", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertForEmptyOrderAmount() {
        
        let alert = UIAlertController(title: "受注額が空欄です", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

