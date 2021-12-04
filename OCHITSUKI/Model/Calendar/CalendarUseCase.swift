//
//  CalendarUseCase.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/18.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

protocol CalendarLogic: AnyObject {
    func dateManager(year: Int, month: Int)
    func numberOfWeeks(year: Int, month: Int)
}

//カレンダーに関する計算を担う
class CalendarUseCase: CalendarLogic {
    
    //プロトコル
    var responseForCalendar: ResponseForCalendar?
    
    private let daysPerWeek = 7
    
    //閏年の確認
    private let isLeapYear = { (year: Int) in year % 400 == 0 || (year % 4 == 0 && year % 100 != 0) }
    
    //曜日の計算
    private let zellerCongruence = { (year: Int, month: Int, day: Int) in (year + year/4 - year/100 + year/400 + (13 * month + 8)/5 + day) % 7 }
    
    //Cellに表示される日にち
    func dateManager(year: Int, month: Int) {
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        let numberOfCells = numberOfWeeks(year, month) * daysPerWeek
        let days = numberOfDays(year, month)
        let daysArray = alignmentOfDays(firstDayOfWeek, numberOfCells, days)
        responseForCalendar?.responseDateManager(response: daysArray)
    }
    
    //週の数の計算結果をどこかへ飛ばす
    func numberOfWeeks(year: Int, month: Int) {
        let weeks = numberOfWeeks(year, month)
        responseForCalendar?.responseNumberOfWeeks(response: weeks)
    }
    
}

//MARK:- Core Logic
extension CalendarUseCase {
    
    //年月日を入れると曜日が返ってくる
    private func dayOfWeek(_ year: Int, _ month: Int, _ day: Int) -> Int {
        var year = year
        var month = month
        if month == 1 || month == 2 {
            year -= 1
            month += 12
        }
        return zellerCongruence(year, month, day)
    }
    
    //週の数の計算
    private func numberOfWeeks(_ year: Int, _ month: Int) -> Int {
        if conditionFourWeeks(year, month) {
            return 4
        } else if conditionSixWeeks(year, month) {
            return 6
        } else {
            return 5
        }
    }
    
    //年月を入れるとその月の日数を返す（閏年も対応）
    private func numberOfDays(_ year: Int, _ month: Int) -> Int {
        var monthMaxDay = [1:31, 2:28, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30, 12:31]
        if month == 2, isLeapYear(year) {
            monthMaxDay.updateValue(29, forKey: 2)
        }
        return monthMaxDay[month]!
    }
    
    //4週の月かどうか
    private func conditionFourWeeks(_ year: Int, _ month: Int) -> Bool {
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        return !isLeapYear(year) && month == 2 && (firstDayOfWeek == 0)
    }
    
    //6週の月かどうか
    private func conditionSixWeeks(_ year: Int, _ month: Int) -> Bool {
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        let days = numberOfDays(year, month)
        return (firstDayOfWeek == 6 && days == 30) || (firstDayOfWeek >= 5 && days == 31)
    }
    
    //表示される日にちがdaysArrayに格納され，最終的にCalendarViewControllerに送られます
    private func alignmentOfDays(_ firstDayOfWeek: Int, _ numberOfCells: Int, _ days: Int) -> [String] {
        var daysArray: [String] = []
        var dayCount = 0
        for i in 0 ... numberOfCells {
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
