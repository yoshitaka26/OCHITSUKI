//
//  ScrollViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/18.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit
import RealmSwift

class ScrollViewController: UIViewController {
    var titleName: String = "案件"
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var grossProfit: UILabel!
    @IBOutlet weak var orderDatePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor(named: "wordBoldColor")
        
        self.navigationController?.isNavigationBarHidden = false
        
        addButton.layer.cornerRadius = addButton.frame.size.height / 4
        if #available(iOS 13.4, *) {
            orderDatePicker.preferredDatePickerStyle = .wheels
        } 
        orderDatePicker.setValue(UIColor(named: "wordColor"), forKeyPath: "textColor")
        orderDatePicker.setValue(true, forKeyPath: "highlightsToday")
        
        scrollView.isPagingEnabled = false
        
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
          titleName = name
        }
        mainTitleLabel.text = "\(titleName)入力"
        textReset()
    }
    
    @IBAction func projectButtonPressed(_ sender: UIButton) {
        addInfo(name: "\(titleName)入力", label: projectTitle)
    }
    @IBAction func orderButtonPressed(_ sender: UIButton) {
        addInfo(name: "受注額入力", label: orderAmount)
    }
    @IBAction func grossButtonPressed(_ sender: UIButton) {
        addInfo(name: "粗利額入力", label: grossProfit)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if checkForEmptyLabel() {
            guard let title = projectTitle.text else { return }
            guard let order = orderAmount.text else { return }
            guard let gross = grossProfit.text else { return }
            let date: Double = orderDatePicker.date.timeIntervalSince1970
            
            let dataModel: OchitsukiDataModel = OchitsukiDataModel(value: ["title": title, "orderAmountUnit": order, "grossProfitUnit": gross, "orderDate": date])
            let realm = try! Realm()
            try! realm.write({
                realm.add(dataModel)
            })
            
            closeAndFinsh()
        }
    }
    
    
    
    func addInfo(name: String, label: UILabel) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "\(name)", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "入力", style: .default) { (action) in
            label.text = textFiled.text!
            label.textColor = .wordColor
        }
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        alert.addTextField { (alertTextFiled) in
            switch name {
            case "案件入力":
                alertTextFiled.placeholder = "株式会社おちつき"
            case "受注額入力":
                alertTextFiled.placeholder = "30000円"
            case "粗利額入力":
                alertTextFiled.placeholder = "5000円"
            default:
                alertTextFiled.placeholder = "..."
            }
            
            textFiled = alertTextFiled
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func checkForEmptyLabel() -> Bool {
        guard let project = projectTitle.text else { return false }
        guard let order = orderAmount.text else { return false }
        guard let gross = grossProfit.text else { return false }
        
        if project.isEmpty || project == titleName {
            alertForEmptyText(title: "案件名が空欄です")
            return false
        }
        
        if order.isEmpty || order == ORDER_AMOUNT {
            alertForEmptyText(title: "受注額が空欄です")
            return false
        }
        
        if gross == GROSS_PROFIT {
            grossProfit.text = String()
        }
        return true
    }
    
    
    func alertForEmptyText(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func closeAndFinsh() {
        let alert = UIAlertController(title: "入力完了しました", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.textReset()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func textReset() {
        projectTitle.text = "\(titleName)"
        orderAmount.text = "受注額"
        grossProfit.text = "粗利額"
        projectTitle.textColor = .placeholderColor
        orderAmount.textColor = .placeholderColor
        grossProfit.textColor = .placeholderColor
        scrollView.scrollsToTop = true
        
    }
}
