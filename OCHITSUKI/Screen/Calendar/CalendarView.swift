//
//  CalendarView.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var calendarLogic = CalendarViewModel()
    @Binding var listViewModel: ListViewModel
    @State private var currentDate = Date()
    @State private var daysArray: [String] = []
    @State private var numberOfWeeks: Int = 0
    @State private var dayOfWeekLabels: [String] = []

    private func updateDayOfWeekLabels() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dayOfWeekLabels = dateFormatter.veryShortWeekdaySymbols ?? []

        // 日曜始まりにする場合（必要に応じて）
        if let sunday = dayOfWeekLabels.last {
            dayOfWeekLabels.removeLast()
            dayOfWeekLabels.insert(sunday, at: 0)
        }
    }

    private func isWeekend(index: Int) -> Bool {
        // 0が日曜、6が土曜の場合
        return index == 0 || index == 6
    }

    var body: some View {
        VStack(spacing: 0) {
            // カスタムナビゲーションバー
            HStack {
                Button("< 前月") { changeMonth(by: -1) }
                Spacer()
                Text(getMonthYearString())
                    .font(.headline)
                Spacer()
                Button("次月 >") { changeMonth(by: 1) }
            }
            .padding(.horizontal)
            .frame(height: 44)
            .background(Color(UIColor.systemBackground))

            // 曜日ヘッダー
            HStack(spacing: 0) {
                ForEach(0..<dayOfWeekLabels.count, id: \.self) { index in
                    Text(dayOfWeekLabels[index])
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                        .foregroundColor(isWeekend(index: index) ? .red : .primary)
                }
            }
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))

            // カレンダーグリッド
            VStack(spacing: 1) {
                ForEach(0..<numberOfWeeks, id: \.self) { week in
                    HStack(spacing: 1) {
                        ForEach(0..<7, id: \.self) { day in
                            let index = week * 7 + day
                            if index < daysArray.count, let dayInt = Int(daysArray[index]) {
                                Button {
                                    changeToSpecificDay(dayInt)
                                } label: {
                                    DayCell(
                                        currentDate: $currentDate,
                                        salesRecordsCount: (listViewModel.salesRecordForSpecificDate(current: getSpecificDateForDayCell(dayInt)) ?? []).count,
                                        day: dayInt,
                                        isToday: isToday(day: dayInt)
                                    )
                                }
                                .buttonStyle(.plain)
                            } else {
                                Color.clear
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            TabView {
                if let salesRecords = listViewModel.salesRecordForSpecificDate(current: currentDate) {
                    ForEach(salesRecords) { salesRecord in
                        VStack {
                            Text(salesRecord.title)
                            HStack {
                                Text("受注")
                                    .frame(width: 160, alignment: .leading)
                                Spacer()
                                Text(salesRecord.formattedActualRevenue)
                                    .fontWeight(.semibold)
                            }
                            .font(.body)

                            HStack {
                                Text("粗利")
                                    .frame(width: 160, alignment: .leading)
                                Spacer()
                                Text(salesRecord.formattedGrossProfit)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }
                            .font(.body)
                        }
                    }
                    .padding(30)
                }
                else {
                    Text("登録がありません")
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 120)
        }
        .onAppear {
            updateDayOfWeekLabels()
            updateCalendar()
            listViewModel.fetch()
        }
    }

    /// カレンダーの表示を更新する
    private func updateCalendar() {
        let year = Calendar.current.component(.year, from: currentDate)
        let month = Calendar.current.component(.month, from: currentDate)

        daysArray = calendarLogic.dateManager(year: year, month: month)
        numberOfWeeks = calendarLogic.numberOfWeeks(year, month)
    }

    /// 月を変更する
    /// - Parameter months: 変更する月数（正の値で次の月、負の値で前の月）
    private func changeMonth(by months: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: months, to: currentDate) {
            currentDate = newDate
            updateCalendar()
        }
    }

    /// 指定した日に変更する
    /// - Parameter day: 変更したい日（1-31）
    private func changeToSpecificDay(_ day: Int) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day

        if let newDate = calendar.date(from: components) {
            currentDate = newDate
        }
    }

    private func getSpecificDateForDayCell(_ day: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day

        return calendar.date(from: components)!
    }

    /// 現在表示中の年月を文字列で返す
    private func getMonthYearString() -> String {
        let dateFormatter = DateFormatter()
        let locale = Locale.current

        if locale.identifier.starts(with: "ja") {
            // 日本語環境の場合
            dateFormatter.dateFormat = "yyyy年M月"
        } else {
            // その他の言語環境の場合
            dateFormatter.dateFormat = "MMMM yyyy"
        }

        dateFormatter.locale = locale
        return dateFormatter.string(from: currentDate)
    }

    /// 指定された日が今日かどうかを判定する
    private func isToday(day: Int) -> Bool {
        let today = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let current = Calendar.current.dateComponents([.day, .month, .year], from: currentDate)
        return day == today.day! && today.month == current.month && today.year == current.year
    }
}

/// カレンダーの日付セルを表示するビュー
struct DayCell: View {
    @Binding var currentDate: Date
    let salesRecordsCount: Int
    let day: Int
    let isToday: Bool

    var isCurrentDay: Bool {
        let current = Calendar.current.dateComponents([.day, .month, .year], from: currentDate)
        return Int(day) == current.day
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Text(String(day))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(10)
                .background(
                    isCurrentDay ? Color.accentColor.opacity(isToday ? 0.8 : 0.3) : Color.clear
                )
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                )
            if salesRecordsCount > 0 {
                Text(String(salesRecordsCount))
                    .bold()
                    .font(.largeTitle)
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview(body: {
    CalendarView(listViewModel: .constant(ListViewModel()))
})
