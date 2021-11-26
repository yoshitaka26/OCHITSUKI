//
//  DataRecordModel.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/01.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

struct DataRecordModel {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    func saveItems(projectArray: [ProjectDataModel]) {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(projectArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encording item, \(error)")
        }
    }
    
    func loadItems() -> [ProjectDataModel]? {
        var projectArray = [ProjectDataModel]()
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                projectArray = try decoder.decode([ProjectDataModel].self, from: data)
            } catch {
                print("Error decoding, \(error)")
            }
        } else {
            return nil
        }
        return projectArray
    }
    
    func deleteData() {
        do {
            try FileManager.default.removeItem(at: dataFilePath!)
        } catch {
            print("Error encording item, \(error)")
        }
    }
}
