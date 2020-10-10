//
//  ProjectDataModel.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/01.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

struct ProjectDataModel : Codable {
    let projectName: String
    let orderAmount: String
    let orderDate: Double
}

extension ProjectDataModel: Comparable {
    static func < (lhs: ProjectDataModel, rhs: ProjectDataModel) -> Bool {
        return lhs.orderDate < rhs.orderDate
    }
}

