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
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var resultButton: UIButton!
    
    override func viewDidLoad() {
        addNewButton.layer.cornerRadius = addNewButton.frame.size.height / 4

        resultButton.layer.cornerRadius = resultButton.frame.size.height / 4
    }
    
    @IBAction func addNewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToAddView", sender: self)
    }
    
    @IBAction func resultButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToTableView", sender: self)
    }
    
}
