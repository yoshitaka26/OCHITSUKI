//
//  NumberCommasExtension.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/16.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}


extension String {
    func insertCommas() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3

        if let number = Int(self) {
            return formatter.string(from: NSNumber(value: number)) ?? self
        }
        return self
    }
}

extension Int {
    var formattedWithCommas: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
