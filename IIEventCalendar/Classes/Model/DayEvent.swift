//
//  DayEvent.swift
//  EventCalendar
//
//  Created by ice on 2019/10/23.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import Foundation
import UIKit

enum TimeSession: Int {
    case none = -1
    case allDay = 0
    case middleNight = 1
    case morning = 2
    case afternoon = 3
    case night = 4
}

public protocol CalendarEvent {
    var startDateTime: String { get }
    var endDateTime: String { get }
    var isAllDay: Bool { get }
    var color: String { get }
    var title: String { get }
    var isAlert: Bool { get }
    var eventId: String? { get }
    var isJoin: Bool { get }
    var name: String? { get }
    var style: DayEvent.Style? { get }
}

extension CalendarEvent {
    func getTimeRange(_ numberOfDay: Int) -> (String, TimeSession) {
        var result = "-"
        var type = TimeSession.none
       
        if isAllDay {
            result = "全天"
            type = .allDay
        } else {
            if let start = startDateTime.toLocalDate(), let end = endDateTime.toLocalDate() {
                let theDay = start.dateByAddDays(numberOfDay)
                if theDay.startOfDay == start.startOfDay, numberOfDay == 0 {
                    if theDay.endOfDay != end.endOfDay {
                        let s1 = theDay.stringFormat("ah:mm")
                        result = "\(s1)-下午11:59"
                        type = getTimeType(theDay)
                    } else {
                        let s1 = theDay.stringFormat("ah:mm")
                        let s2 = end.stringFormat("ah:mm")
                        result = "\(s1)-\(s2)"
                        type = getTimeType(theDay)
                    }
                } else if theDay.endOfDay != end.endOfDay {
                    result = "全天"
                    type = .allDay
                } else {
                    let s2 = end.stringFormat("ah:mm")
                    result = "上午12:00-\(s2)"
                    type = .middleNight
                }
            }
        }
        
        if result == "上午12:00-上午12:00" {
            result = "全天"
            type = .allDay
        }
        return (result, type)
    }
    
    private func getTimeType(_ date: Date) -> TimeSession {
        let hh = date.stringFormat("HH")
        if hh < "06" {
            return .middleNight
        } else if hh < "12" {
            return .morning
        } else if hh < "18" {
            return .afternoon
        } else {
            return .night
        }
    }
}

public struct DayEvent {
    public enum Status {
        case none
        case begin
        case during
        case end
    }
    
    public enum Sort {
        case none, duringDays, startDate
    }
    
    public enum Style {
        case allDay, halfDay, holiday
    }
    
    var destription: String = ""
    var numberOfDay: Int = 1
    var duringDays: Int = 1
    var status: Status = .begin
    var color: UIColor
    var name: String?
    
    var timeInterval: String = "-"
    var session: TimeSession = .none
    var isAlert: Bool = false
    var eventID: String?
    var isJoin: Bool = false
    
    var style: Style = .allDay
    
    public static func expandEventsWithDay(_ events: [CalendarEvent], sort: Sort = .none) -> [String: [DayEvent]] {
        var sortedEvents = events
        if sort == .duringDays {
            sortedEvents = sortByDuringDays(events)
        } else if sort == .startDate {
            sortedEvents = sortByStartDate(events)
        }
        
        var result: [String: [DayEvent]] = [:]
        // expand events
        for event in sortedEvents {
            if let startDate = event.startDateTime.toLocalDate(), let endDate = event.endDateTime.toLocalDate() {
                let start = startDate.startOfDay
                let end = endDate.endOfDay
                let days: Int = start.days(between: end) + 1
                let components = Calendar.current.dateComponents([.hour], from: startDate, to: endDate)
                let hours: Int = components.hour ?? 0
                
                let insertIndex = findInsertIndex(in: result, start: start, days: days)
                // add event to current place
                for i in 0..<days {
                    let e = expandEvent(event, days: days, hours: hours, index: i)
                    let key = start.dateByAddDays(i).stringFormat("yyyy-MM-dd")
                    var des: [DayEvent] = result[key] ?? []
                    let empty = emptyDayEvent()
                    for j in 0...insertIndex {
                        if des.count <= j {
                            des.append(empty)
                        }
                        if j == insertIndex {
                            des[j] = e
                        }
                    }
                    result[key] = des
                }
            }
        }
        
        return result
    }
    
    private static func findInsertIndex(in result: [String: [DayEvent]], start: Date, days: Int) -> Int {
        // calculate empty index for event
        var insertIndex = 0
        var i = 0
        while i < days {
            let key = start.dateByAddDays(i).stringFormat("yyyy-MM-dd")
            let events: [DayEvent] = result[key] ?? []
            let firstEmptyIndex = getFirstEmptyIndex(with: events, after: insertIndex)
            if insertIndex == firstEmptyIndex {
                i += 1
            } else {
                insertIndex = firstEmptyIndex
                i = 0
            }
        }
        
        return insertIndex
    }
    
    private static func expandEvent(_ event: CalendarEvent, days: Int, hours: Int, index: Int) -> DayEvent {
        let style = event.style ?? (event.isAllDay ? .allDay : days > 1 ? hours >= 24 ? .allDay : .halfDay : .halfDay)
        let status: DayEvent.Status = index == 0 ? .begin : index == days - 1 ? .end : .during
        let (interval, session) = event.getTimeRange(index)
        
        return DayEvent(destription: event.title,
                         numberOfDay: (index+1),
                         duringDays: days,
                         status: status,
                         color: UIColor(rgba: event.color),
                         name: event.name,
                         timeInterval: interval,
                         session: session,
                         isAlert: event.isAlert,
                         eventID: event.eventId,
                         isJoin: event.isJoin,
                         style: style)
    }
    
    private static func getFirstEmptyIndex(with dayEvents: [DayEvent], after index: Int) -> Int {
        if dayEvents.count < index {
            return index
        }
        
        for i in index..<dayEvents.count {
            let event = dayEvents[i]
            if event.color == .clear {
                return i
            }
        }
        
        return dayEvents.count
    }
    
    private static func emptyDayEvent() -> DayEvent {
        return DayEvent(color: .clear, eventID: "")
    }
    
    private static func sortByHoliday(_ origin: [CalendarEvent]) -> [CalendarEvent] {
        var events = origin
        events.sort { (e1, _) -> Bool in
            if let style = e1.style, style == .holiday {
                return true
            } else {
                return false
            }
        }
        return events
    }
    
    private static func sortByDuringDays(_ origin: [CalendarEvent]) -> [CalendarEvent] {
        var events = sortByHoliday(origin)
        events.sort { (e1, e2) -> Bool in
            if let start1 = e1.startDateTime.toLocalDate(), let end1 = e1.endDateTime.toLocalDate(), let start2 = e2.startDateTime.toLocalDate(), let end2 = e2.endDateTime.toLocalDate() {
                let day1: Int = (Calendar.current.dateComponents([.day], from: start1.startOfDay, to: end1.endOfDay).day ?? 0) + 1
                let day2: Int = (Calendar.current.dateComponents([.day], from: start2.startOfDay, to: end2.endOfDay).day ?? 0) + 1
                
                return day1 > day2
            }
            return false
        }
        return events
    }
    
    private static func sortByStartDate(_ origin: [CalendarEvent]) -> [CalendarEvent] {
        var events = sortByHoliday(origin)
        events.sort { (e1, e2) -> Bool in
            if let start1 = e1.startDateTime.toLocalDate(), let start2 = e2.startDateTime.toLocalDate() {
                return start1 < start2
            }
            return false
        }
        return events
    }
}

extension NSNotification.Name {
    static var eventUpdate = NSNotification.Name(rawValue: "CalendarEventUpdate")
    static var eventUpdateComplete = NSNotification.Name(rawValue: "CalendarEventUpdateComplete")
    static var refreshCalendar = NSNotification.Name(rawValue: "refreshCalendar")
}

struct EventNotify {
    var eventID: String
    var isJoin: Bool
}
