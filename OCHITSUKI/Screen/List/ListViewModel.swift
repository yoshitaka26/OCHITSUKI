//
//  ListViewModel.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import RealmSwift
import SwiftData

@Observable
final class ListViewModel {
    let context: ModelContext? = ModelContext.shared
    var salesRecordsForList: [Date: [SalesRecord]] = [:]
    var dateOrder: [Date] = []
    var editSalesRecord: SalesRecord?
    private var salesRecordsForCalendar: [SalesRecord] = []

    func salesRecordForSpecificDate(current: Date) -> [SalesRecord]? {
        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: current)
        let salesRecordsForSpecificDate = salesRecordsForCalendar.filter { salesRecord in
            let orderDate = Calendar.current.dateComponents(
                [.day, .month, .year],
                from: salesRecord.orderDate
            )
            return orderDate.year == currentDate.year && orderDate.month == currentDate.month && orderDate.day == currentDate.day
        }
        guard !salesRecordsForSpecificDate.isEmpty else { return nil }
        return salesRecordsForSpecificDate
    }

    func fetch() {
        let sort = SortDescriptor(\SalesRecord.orderDate)
        let fetchDescriptor = FetchDescriptor<SalesRecord>(sortBy: [sort])

        guard let fetchedSalesRecords = try? context?.fetch(fetchDescriptor) else { return }

        salesRecordsForCalendar = fetchedSalesRecords

        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "yyyy/MM"

        salesRecordsForList = Dictionary(grouping: fetchedSalesRecords) { salesRecord -> Date in
            let formatedDate = f.string(from: salesRecord.orderDate)
            return f.date(from: formatedDate)!
        }
        .reduce(into: [Date: [SalesRecord]]()) { dic, tuple in
            dic[tuple.key] = tuple.value.sorted { $0.orderDate > $1.orderDate}
        }
        // 日付順を保持するための配列
        dateOrder = Array(salesRecordsForList.keys).sorted { $0 > $1 }
    }

    func delete(element: SalesRecord) {
        context?.delete(element)
        fetch()
    }

    func duplicate(element: SalesRecord) {
        let salesModel = SalesRecord(
            title: element.title,
            actualRevenue: element.actualRevenue,
            grossProfit: element.grossProfit,
            orderDate: element.orderDate
        )
        context?.insert(salesModel)

        fetch()
    }

    func updateSalesRecord(_ salesRecord: SalesRecord, title: String, actualRevenue: Double, grossProfit: Double, orderDate: Date) {
        salesRecord.title = title
        salesRecord.actualRevenue = actualRevenue
        salesRecord.grossProfit = grossProfit
        salesRecord.orderDate = orderDate

        try? context?.save()
        fetch()
    }
}
