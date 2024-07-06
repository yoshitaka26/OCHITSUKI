//
//  CalendarViewModel.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import Combine

/// カレンダーの日付計算ロジックを担当するクラス
final class CalendarViewModel: ObservableObject {
    private let daysPerWeek = 7

    /// 閏年かどうかを判定する
    private let isLeapYear = { (year: Int) in year % 400 == 0 || (year % 4 == 0 && year % 100 != 0) }

    /// ツェラーの公式を用いて曜日を計算する
    private let zellerCongruence = { (year: Int, month: Int, day: Int) in
        (year + year/4 - year/100 + year/400 + (13 * month + 8)/5 + day) % 7
    }

    /// 指定された年月のカレンダーデータ（日付の配列）を生成する
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 日付の文字列配列
    func dateManager(year: Int, month: Int) -> [String] {
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        let numberOfCells = numberOfWeeks(year, month) * daysPerWeek
        let days = numberOfDays(year, month)
        return alignmentOfDays(firstDayOfWeek, numberOfCells, days)
    }

    /// 指定された年月の週数を計算する
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 週数
    func numberOfWeeks(_ year: Int, _ month: Int) -> Int {
        if conditionFourWeeks(year, month) {
            return 4
        } else if conditionSixWeeks(year, month) {
            return 6
        } else {
            return 5
        }
    }

    /// 指定された年月日の曜日を計算する（0:日曜日 ... 6:土曜日）
    private func dayOfWeek(_ year: Int, _ month: Int, _ day: Int) -> Int {
        var year = year
        var month = month
        if month == 1 || month == 2 {
            year -= 1
            month += 12
        }
        return zellerCongruence(year, month, day)
    }

    /// 指定された年月の日数を返す
    private func numberOfDays(_ year: Int, _ month: Int) -> Int {
        var monthMaxDay = [1:31, 2:28, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30, 12:31]
        if month == 2, isLeapYear(year) {
            monthMaxDay.updateValue(29, forKey: 2)
        }
        return monthMaxDay[month]!
    }

    /// 4週間のカレンダーになる条件を判定する
    private func conditionFourWeeks(_ year: Int, _ month: Int) -> Bool {
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        return !isLeapYear(year) && month == 2 && (firstDayOfWeek == 0)
    }

    /// 6週間のカレンダーになる条件を判定する
    private func conditionSixWeeks(_ year: Int, _ month: Int) -> Bool {
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        let days = numberOfDays(year, month)
        return (firstDayOfWeek == 6 && days == 30) || (firstDayOfWeek >= 5 && days == 31)
    }

    /// カレンダーグリッドに表示する日付の配列を生成する
    private func alignmentOfDays(_ firstDayOfWeek: Int, _ numberOfCells: Int, _ days: Int) -> [String] {
        var daysArray: [String] = []
        var dayCount = 0
        for i in 0 ..< numberOfCells {
            let diff = i - firstDayOfWeek
            if diff < 0 || dayCount >= days {
                daysArray.append("")
            } else {
                daysArray.append(String(diff + 1))
                dayCount += 1
            }
        }
        return daysArray
    }
}
