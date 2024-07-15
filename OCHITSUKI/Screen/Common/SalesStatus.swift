//
//  SalesStatus.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/07.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

let allSalesStatus: [SalesStatus] = SalesStatus.allCases

enum SalesStatus: Int, Hashable, CaseIterable, Codable {
    case prospect, ordered, closed, lost

    var title: String {
        switch self {
        case .prospect: "予定"
        case .ordered: "受注"
        case .closed: "売上"
        case .lost: "失注"
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

