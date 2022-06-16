//
//  Date.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 16.06.2022.
//

import Foundation

extension Date {
    var weekDay: Int {
        // TODO: need to test more detail on different localizations
        let calendar = Calendar(identifier: .gregorian)
        var n = calendar.component(.weekday, from: self)
        let firstDay = Calendar.current.firstWeekday
        if firstDay == 1 { // first day of the week is Sunday
            n -= 1
        }
        return n
    }
}
