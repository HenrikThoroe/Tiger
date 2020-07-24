//
//  Date.swift
//  Tiger
//
//  Created by Henrik Thoroe on 24.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation

extension Date {
    
    enum Weekday: String {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
    
    func find(weekday: Weekday, direction: Calendar.SearchDirection) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let allWeekdays = englishWeekdays()
        let searchIndex = (allWeekdays.firstIndex(of: weekday.rawValue) ?? 0) + 1
        var searchDateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        
        searchDateComponents.weekday = searchIndex

        let date = calendar.nextDate(after: self,
                                     matching: searchDateComponents,
                                     matchingPolicy: .nextTime,
                                     direction: direction)
        
        if calendar.component(.weekday, from: self) == searchIndex {
            return self
        }

        return date ?? self
    }
    
    func find(last weekday: Weekday) -> Date {
        find(weekday: weekday, direction: .backward)
    }
    
    func find(next weekday: Weekday) -> Date {
        find(weekday: weekday, direction: .forward)
    }
    
    func startOfCurrentMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let searchDateComponents = calendar.dateComponents([.month, .year], from: self)

        return calendar.date(from: searchDateComponents) ?? self
    }
    
    func isSameDay(as other: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: self, to: other)
        return diff.day == 0
    }
    
    func isBetween(_ start: Date, _ end: Date) -> Bool {
        start.timeIntervalSince1970 <= timeIntervalSince1970 && end.timeIntervalSince1970 >= timeIntervalSince1970
    }
    
    // MARK: Helper Methods
    
    private func englishWeekdays() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        
        return calendar.weekdaySymbols.map { $0.lowercased() }
    }
    
}
