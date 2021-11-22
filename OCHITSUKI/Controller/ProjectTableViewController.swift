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
    
    var titleName: String = "案件"
    
    var schedules = [Date: [ProjectDataModel]]()
    var dateOrder = [Date]()
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = dataRecord.loadItems() {
            projectArray = data
            projectArray.sort()
        }
        prepare()
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
          titleName = name
        }
        
        settingLabel()
        
        tableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "ProjectCell")
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.tintColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 1.0)
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        guard let nvc = self.navigationController else { return }
        guard let tbc = nvc.tabBarController else { return }
        tbc.dismiss(animated: true)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedules.keys.count
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let targetMonth = dateOrder[section]
        
        let label = UILabel()
        label.backgroundColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 0.7)
        label.textColor = .white
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        let orderMonth = "\(formatter.string(from: targetMonth))"
        label.text = orderMonth
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let targetDate = dateOrder[section]
        return schedules[targetDate, default: []].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        let targetDate = dateOrder[indexPath.section]
        
        guard let project = schedules[targetDate]?[indexPath.row] else {
            return cell
        }
        
        let name = project.projectName
        let value = project.orderAmount
        let profit = project.grossProfit
        
        let date = Date(timeIntervalSince1970: project.orderDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let dateorder = "\(formatter.string(from: date))"
        
        cell.projectLaber.text = name
        cell.orderAmountLaber.text = value
        cell.grossProfitLabel.text = profit
        cell.dateLaber.text = dateorder
        
        cell.selectionStyle = .none
        
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let targetDate = dateOrder[indexPath.section]
        
        guard let project = schedules[targetDate]?[indexPath.row] else { return }
        
        
        delete(element: project)
        
        dataRecord.saveItems(projectArray: projectArray)
        
        prepare()

        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    private func settingLabel() {
        title = "\(titleName)リスト"
    }
    
    private func prepare() {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "yyyy/MM"
        
        schedules = Dictionary(grouping: projectArray) { project -> Date in
            let date = Date(timeIntervalSince1970: project.orderDate)
            let formatedDate = f.string(from: date)
            return f.date(from: formatedDate)!
        }
        .reduce(into: [Date: [ProjectDataModel]]()) { dic, tuple in
            dic[tuple.key] = tuple.value.sorted { $0.orderDate < $1.orderDate}
        }
        
        // 日付順を保持するための配列
        dateOrder = Array(schedules.keys).sorted { $0 < $1 }
    }
    
    func delete(element: ProjectDataModel) {
        projectArray = projectArray.filter({ $0 != element })
    }
    
}


