//
//  OchitsukiDataManager.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2021/12/04.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import RealmSwift

class OchitsukiDataManager {
    static var shared = OchitsukiDataManager()
    
    func loadDataFromRealm() -> [OchitsukiDataModel] {
        let realm = try! Realm()
        let tasks = realm.objects(OchitsukiDataModel.self)
        let realmData = tasks.sorted(byKeyPath: "orderDate", ascending: true)
        
        let arrayData = Array(realmData)
        return arrayData
    }
}
