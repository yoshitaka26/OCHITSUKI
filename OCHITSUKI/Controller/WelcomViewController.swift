//
//  WelcomViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/09/30.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class WelcomViewController: UIViewController {
    let dataRecord = DataRecordModel()
    var titleName: String = "案件"
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var addButtonName: UILabel!
    
    override func viewDidLoad() {
        addNewButton.layer.cornerRadius = addNewButton.frame.size.height / 4
        
        settingButton.layer.cornerRadius = settingButton.frame.size.height / 4
        
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
            titleName = name
        }
        
        self.navigationController?.isNavigationBarHidden = true
        
        addButtonName.text = "\(titleName)入力"
    }
    
    @IBAction func addNewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToStart", sender: self)
    }
}
