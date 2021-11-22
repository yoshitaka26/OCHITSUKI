//
//  CalendarController.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/18.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//


import Foundation

protocol RequestForCalendar: AnyObject {
    func requestNumberOfWeeks(request: DateItems.ThisMonth.Request)
    func requestDateManager(request: DateItems.ThisMonth.Request)
    
    func requestNumberOfWeeks(request: DateItems.MoveMonth.Request)
    func requestDateManager(request: DateItems.MoveMonth.Request)
}

class CalendarController: RequestForCalendar {

    var calendarLogic: CalendarLogic?
    
    func requestNumberOfWeeks(request: DateItems.ThisMonth.Request) {
        calendarLogic?.numberOfWeeks(year: request.year, month: request.month)
    }
    
    func requestDateManager(request: DateItems.ThisMonth.Request) {
        calendarLogic?.dateManager(year: request.year, month: request.month)
    }
    
    func requestDateManager(request: DateItems.MoveMonth.Request) {
        calendarLogic?.dateManager(year: request.year, month: request.month)
    }
    
    func requestNumberOfWeeks(request: DateItems.MoveMonth.Request) {
        calendarLogic?.numberOfWeeks(year: request.year, month: request.month)
    }
    
}
