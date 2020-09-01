//
//  Date+Extension.swift
//  EventCalendar
//
//  Created by ice on 2020/8/13.
//  Copyright © 2020 iceboxidev. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func stringFormat(_ format: String = "yyyy-MM-dd") -> String {
        return self.formatting(format, isUTC: false)
    }
    
    func stringUTCFormat(_ format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> String {
        return self.formatting(format, isUTC: true)
    }
    
    func formatting(_ format: String, isUTC: Bool) -> String {
        let dateFormatter = DateFormatter()

        if isUTC {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        
        dateFormatter.dateFormat = format
        
        let dateString = dateFormatter.string(from: self)
        
        return dateString
    }
    
    func dateByAddDays(_ days: Int) -> Date {
        return self.dateByAdd({ comps -> Void in
            comps.day = days
        })
    }
    
    mutating func nextDay() {
        self = self.dateByAddDays(1)
    }
    
    func dateByAdd(_ processing:  (_ comps: inout DateComponents) -> Void) -> Date {
        
        var comps = DateComponents()
        
        processing(&comps)
        
        return (Calendar.current as NSCalendar).date(byAdding: comps, to: self, options: NSCalendar.Options(rawValue: 0)) ?? Date()

    }
    
    static func dateByISO8601String(_ dateString: String, hasMillisecond: Bool) -> Date? {
        
        let dateFormatter = DateFormatter()
        if hasMillisecond {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        }
        
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from: dateString)
    }
    
    var weekday: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        
        switch weekday {
        case 1: return "日"
        case 2: return "一"
        case 3: return "二"
        case 4: return "三"
        case 5: return "四"
        case 6: return "五"
        case 7: return "六"
        default: return ""
        }
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()
}

extension Date {
    func days(after date: Date) -> Int {
        let start = date.startOfDay
        let end = self.endOfDay
        let components = Calendar.current.dateComponents([.day], from: start, to: end)
        return (components.day ?? 0)
    }
}

extension Date {
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 0, to: sunday!)!
    }
    
    var endOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 6, to: sunday!)!
    }
    
    var startOfPreviousWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: -6, to: sunday!)!
    }
    
    var endOfPreviousWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 0, to: sunday!)!
    }
    
    var startDateOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endDateOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth)!
    }
    
    func getMonth(_ offset: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: offset, to: self)!
    }
    
    func days(between date: Date) -> Int {
        var start = self.startOfDay
        var end = date.endOfDay
        if date < self {
            start = date.startOfDay
            end = self.endOfDay
        }
        
        let components = Calendar.current.dateComponents([.day], from: start, to: end)
        return (components.day ?? 0)
    }
}
