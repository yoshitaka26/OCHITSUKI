//
//  EditDataModalViewController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2021/11/26.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RealmSwift

protocol EditDataModalViewControllerDelegate {
    func pushBackFromEditView()
}

class EditDataModalViewController: BaseViewController {
    
    var delegate: EditDataModalViewControllerDelegate?
    var editingData: OchitsukiDataModel?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var orderTextField: UITextField!
    @IBOutlet weak var grossTextField: UITextField!
    @IBOutlet weak var orderDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    private var titleName: String = "案件"
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = editingData else {
            self.dismiss(animated: true)
            return
        }
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
            titleName = name
            mainTitleLabel.text = "\(titleName)修正"
            titleLabel.text = titleName
        }
        saveButton.layer.cornerRadius = saveButton.frame.size.height / 4
        if #available(iOS 13.4, *) {
            orderDatePicker.preferredDatePickerStyle = .compact
        }
        orderDatePicker.datePickerMode = .date
        
        titleTextField.text = data.title
        orderTextField.text = data.orderAmountUnit
        grossTextField.text = data.orderAmountUnit
        orderDatePicker.date = Date(timeIntervalSince1970: data.orderDate)
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let title = titleTextField.text else { return }
        guard let order = orderTextField.text else { return }
        guard let gross = grossTextField.text else { return }
        let date = orderDatePicker.date
        
        guard !title.isEmpty else {
            alertForEmptyText(title: "案件名が空欄です")
            return
        }
        
        let realm = try! Realm()
        guard let data = editingData else { return }
        let tasks = realm.objects(OchitsukiDataModel.self).where { $0.uuid == data.uuid }
        guard let editingData = tasks.first else { return }
        try! realm.write {
            editingData.title = title
            editingData.orderAmountUnit = order
            editingData.grossProfitUnit = gross
            editingData.orderDate = date.timeIntervalSince1970
            editingData.modifyDate = Date()
        }
        self.dismiss(animated: true) {
            self.delegate?.pushBackFromEditView()
        }
    }
}
