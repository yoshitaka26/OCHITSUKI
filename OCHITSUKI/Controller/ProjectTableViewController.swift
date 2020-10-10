//
//  ProjectTableViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/01.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class ProjectTableViewController: UITableViewController {
    let dataRecord = DataRecordModel()
    
    var projectArray = [ProjectDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = dataRecord.loadItems() {
            projectArray = data
            projectArray.sort()
            print(projectArray)
        }
        
        tableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "ProjectCell")
        
        
        
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.tintColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 1.0)
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "BackToHomeFromTable", sender: self)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        let name = projectArray[indexPath.row].projectName
        
        let value = projectArray[indexPath.row].orderAmount
        
        let date = Date(timeIntervalSince1970: projectArray[indexPath.row].orderDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let dateorder = "\(formatter.string(from: date))"
        
        cell.projectLaber.text = name
        cell.orderAmountLaber.text = "\(value)"
        cell.dateLaber.text = dateorder

        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        projectArray.remove(at: indexPath.row)
        dataRecord.saveItems(projectArray: projectArray)
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
}


