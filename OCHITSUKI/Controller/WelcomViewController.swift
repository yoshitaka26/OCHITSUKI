//
//  WelcomViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/09/30.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds
import AppTrackingTransparency

class WelcomViewController: UIViewController {
    let dataRecord = DataRecordModel()
    var titleName: String = "案件"
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var addButtonName: UILabel!
    
    override func viewDidLoad() {
        requestIDFAPermission()

        addNewButton.layer.cornerRadius = addNewButton.frame.size.height / 4
        settingButton.layer.cornerRadius = settingButton.frame.size.height / 4
        
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
            titleName = name
        }
        
        /*
        let a = ProjectDataModel(projectName: "a", orderAmount: "a", grossProfit: "a", orderDate: Date().timeIntervalSince1970)
        let b = ProjectDataModel(projectName: "b", orderAmount: "b", grossProfit: "b", orderDate: Date().timeIntervalSince1970)
        DataRecordModel().saveItems(projectArray: [a, b])
         */
        
        self.navigationController?.isNavigationBarHidden = true
        
        addButtonName.text = "\(titleName)入力"
        
        if let data = dataRecord.loadItems() {
            guard !data.isEmpty else {
                dataRecord.deleteData()
                return
            }
            let realm = try! Realm()
            for d in data {
                let dataModel: OchitsukiDataModel = OchitsukiDataModel(value: ["title": d.projectName, "orderAmountUnit": d.orderAmount, "grossProfitUnit": d.grossProfit, "orderDate": d.orderDate])
                try! realm.write({
                    realm.add(dataModel)
                })
            }
            dataRecord.deleteData()
        }
    }

    func requestIDFAPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            })
        }
    }
    
    @IBAction func addNewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToStart", sender: self)
    }
}
