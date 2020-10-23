//
//  DateItems.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/18.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import Foundation

enum DateItems {
    
    //日にちの取得
    enum ThisMonth {
        struct Request {
            
            var year: Int
            var month: Int
            var day: Int
            
            init() {
                let calendar = Calendar(identifier: .gregorian)
                let date = calendar.dateComponents([.year, .month, .day], from: Date())
                year = date.year!
                month = date.month!
                day = date.day!
            }
        }
    }
    
    enum MoveMonth {
        struct Request {
            
            var year: Int
            var month: Int
            
            init(_ monthCounter: Int) {
                let calendar = Calendar(identifier: .gregorian)
                let date = calendar.date(byAdding: .month, value: monthCounter, to: Date())
                let newDate = calendar.dateComponents([.year, .month], from: date!)
                year = newDate.year!
                month = newDate.month!
            }
        }
    }
    
}
