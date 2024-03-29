//
//  ProjectTableViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/01.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ProjectTableViewController: UITableViewController {
    private var projectArray: Results<OchitsukiDataModel>?
    
    private var schedules = [Date: [OchitsukiDataModel]]()
    private var dateOrder = [Date]()
    private var editingData: OchitsukiDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "ProjectCell")
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.tintColor = .wordColor
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromRealm()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if tableView.numberOfSections > 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月"
            let date = Date()
            let thisMonth = formatter.string(from: date)
            
            for (index, month) in dateOrder.enumerated() {
                let monthFormatted = formatter.string(from: month)
                if thisMonth ==  monthFormatted {
                    let indexPath = IndexPath(row: NSNotFound, section: index)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    return
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        guard let nvc = self.navigationController else { return }
        guard let tbc = nvc.tabBarController else { return }
        tbc.dismiss(animated: true)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedules.keys.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < dateOrder.count {
            let targetDate = dateOrder[section]
            return schedules[targetDate, default: []].count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .buttonColor
        label.textColor = .wordColor
        if section < dateOrder.count {
            let targetMonth = dateOrder[section]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月"
            let orderMonth = "\(formatter.string(from: targetMonth))"
            label.text = "  " + orderMonth
        } else {
            label.text = "  " + "広告"
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < dateOrder.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell

            let targetDate = dateOrder[indexPath.section]
            guard let targetProjects = schedules[targetDate] else { return cell }
            guard indexPath.row < targetProjects.count else { return cell }
            let project = targetProjects[indexPath.row]

            let name = project.title
            let value = project.orderAmountUnit
            let profit = project.grossProfitUnit

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
        } else {
            let cell = UITableViewCell()
            let adSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            let bannerView = GADBannerView(adSize: adSize)
            bannerView.adUnitID = Bundle.main.object(forInfoDictionaryKey: "AdMobSettingViewBannerAdUnitId") as? String
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            cell.contentView.addSubview(bannerView)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bannerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                bannerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                bannerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                bannerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section < dateOrder.count {
            let contextItem1 = UIContextualAction(style: .destructive, title: DELETE) { (contextualAction, view, boolValue) in
                let targetDate = self.dateOrder[indexPath.section]
                guard let targetProjects = self.schedules[targetDate] else { return }
                guard indexPath.row < targetProjects.count else { return }
                let project = targetProjects[indexPath.row]
                self.delete(element: project)
            }

            let contextItem2 = UIContextualAction(style: .normal, title: EDIT) {  (contextualAction, view, boolValue) in
                self.tableView.isEditing = false
                let targetDate = self.dateOrder[indexPath.section]
                guard let targetProjects = self.schedules[targetDate] else { return }
                guard indexPath.row < targetProjects.count else { return }
                self.editingData = targetProjects[indexPath.row]
                self.performSegue(withIdentifier: "ToEditModal", sender: self)
            }
            let contextItem3 = UIContextualAction(style: .normal, title: DUPLICATE) {  (contextualAction, view, boolValue) in
                let targetDate = self.dateOrder[indexPath.section]
                guard let targetProjects = self.schedules[targetDate] else { return }
                guard indexPath.row < targetProjects.count else { return }
                let project = targetProjects[indexPath.row]
                self.duplicate(element: project)
            }

            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem1, contextItem2, contextItem3])

            return swipeActions
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section < dateOrder.count {
            return tableView.isEditing ? .delete : .none
        } else {
            return .none
        }
    }
    
    private func loadDataFromRealm() {
        let realm = try! Realm()
        let tasks = realm.objects(OchitsukiDataModel.self)
        projectArray = tasks.sorted(byKeyPath: "orderDate", ascending: true)
        guard let realmData = projectArray else { return }
        
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "yyyy/MM"
        
        let arrayData = Array(realmData)
        
        schedules = Dictionary(grouping: arrayData) { project -> Date in
            let date = Date(timeIntervalSince1970: project.orderDate)
            let formatedDate = f.string(from: date)
            return f.date(from: formatedDate)!
        }
        .reduce(into: [Date: [OchitsukiDataModel]]()) { dic, tuple in
            dic[tuple.key] = tuple.value.sorted { $0.orderDate < $1.orderDate}
        }
        // 日付順を保持するための配列
        dateOrder = Array(schedules.keys).sorted { $0 < $1 }
        print(dateOrder)
        
        tableView.reloadData()
    }
    
    func delete(element: OchitsukiDataModel) {
        let realm = try! Realm()
        try! realm.write({
            realm.delete(element)
        })
        loadDataFromRealm()
        infoAlertViewWithTitle(title: DELETE_DONE)
    }
    
    func duplicate(element: OchitsukiDataModel) {
        let dataModel: OchitsukiDataModel = OchitsukiDataModel(value: ["title": element.title, "orderAmountUnit": element.orderAmountUnit ?? "", "grossProfitUnit": element.grossProfitUnit ?? "", "orderDate": element.orderDate])
        let realm = try! Realm()
        try! realm.write({
            realm.add(dataModel)
        })
        loadDataFromRealm()
        infoAlertViewWithTitle(title: DUPLICATE_DONE)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEditModal" {
            guard let data = editingData else { return }
            let destinationVC = segue.destination as! EditDataModalViewController
            destinationVC.modalPresentationStyle = .automatic
            destinationVC.delegate = self
            destinationVC.editingData = data
        }
    }
}

extension ProjectTableViewController: EditDataModalViewControllerDelegate {
    func pushBackFromEditView() {
        tableView.setEditing(true, animated: true)
        loadDataFromRealm()
        infoAlertViewWithTitle(title: EDIT_DONE)
    }
}


