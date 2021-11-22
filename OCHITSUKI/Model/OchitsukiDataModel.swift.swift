//
//  OchitsukiDataModel.swift.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2021/11/21.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RealmSwift

class OchitsukiDataModel: Object {
    @Persisted var uuid: UUID
    @Persisted var modifyDate = Date()
    @Persisted var completedFlag: Bool?
    @Persisted var stateFlag: Int8?
    @Persisted var orderDate = Date()
    @Persisted var orderAmount: Float?
    @Persisted var orderAmountUnit: String?
    @Persisted var grossProfit: Float?
    @Persisted var grossProfitUnit: String?
    @Persisted var detail: OchitsukiDetailDataModel?
}

class OchitsukiDetailDataModel: Object { }
