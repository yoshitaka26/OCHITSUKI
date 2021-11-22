//
//  SettingSubTableViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/23.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class SettingSubTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 1.0)

        // UserDefaultsの情報を画面にセットする
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
          textField.text = name
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Keyboardを隠す
        textField.resignFirstResponder()
        
        // 入力された内容を保存する
        UserDefaults.standard.set(textField.text, forKey: "name")
        
        return true
    }

}
