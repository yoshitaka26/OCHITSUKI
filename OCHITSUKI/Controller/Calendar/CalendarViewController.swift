//
//  CalendarViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/18.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

//MARK:- Protocol

//計算結果が回り回ってここへ値が返ってくる
protocol ViewLogic {
    var numberOfWeeks: Int { get set }
    var daysArray: [String]! { get set }
}

//MARK:- UIViewController

class CalendarViewController: UIViewController, ViewLogic {
    
    //MARK: Properties
    var numberOfWeeks: Int = 0
    var daysArray: [String]!
    private var requestForCalendar: RequestForCalendar?
    
    private let date = DateItems.ThisMonth.Request()
    private let daysPerWeek = 7
    private var thisYear: Int = 0
    private var thisMonth: Int = 0
    private var today: Int = 0
    private var isToday = true
    private let dayOfWeekLabel = ["日", "月", "火", "水", "木", "金", "土"]
    private var monthCounter = 0
    
    let dataRecord = DataRecordModel()
    
    var projectArray = [ProjectDataModel]()
    
    //MARK: UI Parts
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func prevButton(_ sender: UIBarButtonItem) {
        prevMonth()
    }
    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        nextMonth()
    }
    
    @IBOutlet weak var projectTitle: UILabel!
    
    //MARK: Initialize
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dependencyInjection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dependencyInjection()
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configure()
        settingLabel()
        getToday()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 1.0)
        
        if let data = dataRecord.loadItems() {
            projectArray = data
            projectArray.sort()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        projectTitle.text = ""
        
        if let data = dataRecord.loadItems() {
            projectArray = data
            projectArray.sort()
        }
        
        collectionView.reloadData()
        
    }
    
    //MARK: Setting
    private func dependencyInjection() {
        let viewController = self
        let calendarController = CalendarController()
        let calendarPresenter = CalendarPresenter()
        let calendarUseCase = CalendarUseCase()
        viewController.requestForCalendar = calendarController
        calendarController.calendarLogic = calendarUseCase
        calendarUseCase.responseForCalendar = calendarPresenter
        calendarPresenter.viewLogic = viewController
    }
    
    private func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        //週数の取得
        requestForCalendar?.requestNumberOfWeeks(request: date)
        //日付の取得
        requestForCalendar?.requestDateManager(request: date)
    }
    
    private func settingLabel() {
        title = "\(String(date.year))年\(String(date.month))月"
    }
    
    private func getToday() {
        thisYear = date.year
        thisMonth = date.month
        today = date.day
    }
    
}

//MARK:- Setting Button Items

//monthCounter=0をはじめに定義してボタンを押すたび，次月の場合は1を加算し，先月の場合は1を引き算します。
extension CalendarViewController {
    
    private func nextMonth() {
        monthCounter += 1
        commonSettingMoveMonth()
        
        projectTitle.text = ""
    }
    
    private func prevMonth() {
        monthCounter -= 1
        commonSettingMoveMonth()
        
        projectTitle.text = ""
    }
    
    private func commonSettingMoveMonth() {
        daysArray = nil
        let moveDate = DateItems.MoveMonth.Request(monthCounter)
        requestForCalendar?.requestNumberOfWeeks(request: moveDate)
        requestForCalendar?.requestDateManager(request: moveDate)
        title = "\(String(moveDate.year))年\(String(moveDate.month))月"
        isToday = thisYear == moveDate.year && thisMonth == moveDate.month ? true : false
        collectionView.reloadData()
    }
    
}

//MARK:- UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : (numberOfWeeks * daysPerWeek)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.backgroundColor = .clear
        
        dayOfWeekColor(label, indexPath.row, daysPerWeek)
        showDate(indexPath.section, indexPath.row, cell, label)
        
        //追加　受注日にマーク
        if indexPath.section != 0 {
            let theDate = "\(title!)\(daysArray[indexPath.row])日"
                 
                 for project in projectArray {
                     let date = Date(timeIntervalSince1970: project.orderDate)
                     let formatter = DateFormatter()
                     formatter.dateFormat = "yyyy年M月d日"
                     let dateorder = "\(formatter.string(from: date))"
                     
                     if theDate == dateorder {
                         label.text?.append("\n※")
                        return cell
                     }
                 }
        }
        
        return cell
    }
    
    private func dayOfWeekColor(_ label: UILabel, _ row: Int, _ daysPerWeek: Int) {
        switch row % daysPerWeek {
        case 0: label.textColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 1.0)
        case 6: label.textColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 1.0)
        default: label.textColor = UIColor(red: 166/255, green: 188/255, blue: 208/255, alpha: 1.0)
        }
    }
    
    private func showDate(_ section: Int, _ row: Int, _ cell: UICollectionViewCell, _ label: UILabel) {
        switch section {
        case 0:
            label.text = dayOfWeekLabel[row]
            cell.backgroundColor = .white
            cell.selectedBackgroundView = nil
        default:
            label.text = daysArray[row]
            cell.backgroundColor = .white
            let selectedView = UIView()
            selectedView.backgroundColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 0.3)
            cell.selectedBackgroundView = selectedView
            markToday(label, cell)
        }
    }
    
    private func markToday(_ label: UILabel, _ cell: UICollectionViewCell) {
        if isToday, today.description == label.text {
            cell.backgroundColor = UIColor(red: 123/255, green: 237/255, blue: 141/255, alpha: 0.5)
        }
        
        //追加　今日の案件を表示
        let theDate = "\(title!)\(today.description)日"
        
        if isToday {
            for project in projectArray {
                let date = Date(timeIntervalSince1970: project.orderDate)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年M月d日"
                let dateorder = "\(formatter.string(from: date))"
                
                if theDate == dateorder {
                    projectTitle.text = project.projectName
                }
            }
        }
    }
    
    
    //追加　押したら案件名表示
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theDate = "\(title!)\(daysArray[indexPath.row])日"
        
        for project in projectArray {
            let date = Date(timeIntervalSince1970: project.orderDate)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月d日"
            let dateorder = "\(formatter.string(from: date))"
            
            if theDate == dateorder {
                projectTitle.text = project.projectName
                return
            } else {
                projectTitle.text = ""
            }
        }
    }
    
}



//MARK:- UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let weekWidth = Int(collectionView.frame.width) / daysPerWeek
        let weekHeight = weekWidth
        let dayWidth = weekWidth
        let dayHeight = (Int(collectionView.frame.height) - weekHeight) / numberOfWeeks
        
        return indexPath.section == 0 ? CGSize(width: weekWidth, height: weekHeight) : CGSize(width: dayWidth, height: dayHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let surplus = Int(collectionView.frame.width) % daysPerWeek
        let margin = CGFloat(surplus)/2.0
        return UIEdgeInsets(top: 0.0, left: margin, bottom: 1.5, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
    
