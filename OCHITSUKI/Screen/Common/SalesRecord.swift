//
//  SalesRecord.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/07.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class SalesRecord {
    // 基本情報
    var title: String = ""

    // 金額関連
    var estimatedRevenue: Double?
    var actualRevenue: Double = 0
    var grossProfit: Double = 0

    // 日付関連
    var orderDate: Date = Date()
    var expectedClosingDate: Date?
    var actualClosingDate: Date?

    // ステータス関連
    var status: SalesStatus = SalesStatus.prospect

    // その他の情報
    var memo: String?
    var tag: String?
    var category: CategoryColor = CategoryColor.gray

    // 管理用
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init(title: String, actualRevenue: Double, grossProfit: Double, orderDate: Date) {
        self.title = title
        self.actualRevenue = actualRevenue
        self.grossProfit = grossProfit
        self.orderDate = orderDate
    }
}

extension SalesRecord {
    func formattedCurrencyValue(_ value: Double) -> String {
        let formatter = NumberFormatter.currencyFormatter
        formatter.locale = Locale.current // ユーザーの現在のロケールを使用

        // 通貨コードを設定（例：USD, JPY など）
        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"

        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    var formattedActualRevenue: String {
        return formattedCurrencyValue(actualRevenue)
    }

    var formattedGrossProfit: String {
        return formattedCurrencyValue(grossProfit)
    }
}
