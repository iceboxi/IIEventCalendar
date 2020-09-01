//
//  File.swift
//  EventCalendar
//
//  Created by ice on 2019/10/30.
//  Copyright © 2019 iceboxidev. All rights reserved.
//

import Foundation
import IIEventCalendar

class CalendarEventManager: EventManager {
    
    enum Change {
        case start, end, both
    }
    
    static let shared = CalendarEventManager()
    private override init() {
        super.init()
    }
    
    private var events: [CalendarEvent] = CalendarEventTester.getEvents()
    private var holidays: [CalendarEvent] = CalendarEventTester.getHolidays()
    
    override func fetchCalendar(_ start: Date?, end: Date?, complete: ((Complete) -> Void)?) {
        self.dayEvents = DayEvent.expandEventsWithDay(self.events + self.holidays, sort: .duringDays)
        
        super.fetchCalendar(start, end: end, complete: complete)
    }
    
    override func reset() {
        
    }
}

class CalendarEventTester {
    static func getEvents() -> [TestModel] {
        let e1 = TestModel(id: "1", startTime: "2020-10-07T04:08:00.000Z", endTime: "2020-10-10T04:08:00.000Z", eventTitle: "一個很長的標題", remark: "一點備註", eventColor: "#3876f2")
        let e2 = TestModel(id: "2", startTime: "2020-10-08T04:08:00.000Z", endTime: "2020-10-14T04:08:00.000Z", eventTitle: "我也不短的標題", remark: "一點備註", eventColor: "#9276f2")
        let e3 = TestModel(id: "3", startTime: "2020-10-12T04:08:00.000Z", endTime: "2020-10-12T05:08:00.000Z", eventTitle: "標題", remark: "一點備註", eventColor: "#3800f2")
        let e4 = TestModel(id: "4", startTime: "2020-10-14T04:08:00.000Z", endTime: "2020-10-15T04:08:00.000Z", eventTitle: "我也要有一個很長的標題", remark: "一點備註", eventColor: "#0076f2")
        let e5 = TestModel(id: "5", startTime: "2020-10-23T04:08:00.000Z", endTime: "2020-10-23T05:08:00.000Z", eventTitle: "一個很長的標題", remark: "一點備註", eventColor: "#387600")
        let e6 = TestModel(id: "6", startTime: "2020-10-11T04:08:00.000Z", endTime: "2020-10-11T05:08:00.000Z", eventTitle: "標題2", remark: "一點備註", eventColor: "#38ffff")
        let e7 = TestModel(id: "7", startTime: "2020-10-11T04:08:00.000Z", endTime: "2020-10-11T05:08:00.000Z", eventTitle: "標題3", remark: "一點備註", eventColor: "#38ffff")
        let e8 = TestModel(id: "8", startTime: "2020-10-11T04:08:00.000Z", endTime: "2020-10-11T05:08:00.000Z", eventTitle: "標題4", remark: "一點備註", eventColor: "#38ffff")
        let e9 = TestModel(id: "9", startTime: "2020-10-11T04:08:00.000Z", endTime: "2020-10-11T05:08:00.000Z", eventTitle: "標題5", remark: "一點備註", eventColor: "#38ffff")
        let e10 = TestModel(id: "10", startTime: "2020-10-11T04:08:00.000Z", endTime: "2020-10-11T05:08:00.000Z", eventTitle: "標題6", remark: "一點備註", eventColor: "#38ffff")
        let e11 = TestModel(id: "11", startTime: "2020-10-11T04:08:00.000Z", endTime: "2020-10-11T05:08:00.000Z", eventTitle: "標題7", remark: "一點備註", eventColor: "#38ffff")
        let e12 = TestModel(id: "12", startTime: "2020-10-11T04:08:00.000Z", endTime: "2020-10-11T05:08:00.000Z", eventTitle: "標題8", remark: "一點備註", eventColor: "#38ffff")
        let e13 = TestModel(id: "13", startTime: "2020-10-14T04:08:00.000Z", endTime: "2020-10-16T05:08:00.000Z", eventTitle: "標題9", remark: "一點備註", eventColor: "#38ffff")
        let e14 = TestModel(id: "14", startTime: "2020-10-14T04:08:00.000Z", endTime: "2020-10-18T05:08:00.000Z", eventTitle: "標題10", remark: "一點備註", eventColor: "#38ffff")
        let e15 = TestModel(id: "15", startTime: "2020-10-14T04:08:00.000Z", endTime: "2020-10-17T05:08:00.000Z", eventTitle: "標11", remark: "一點備註", eventColor: "#38ffff")
        let e16 = TestModel(id: "16", startTime: "2020-10-14T04:08:00.000Z", endTime: "2020-10-17T05:08:00.000Z", eventTitle: "標題12", remark: "一點備註", eventColor: "#38ffff")
        let e17 = TestModel(id: "17", startTime: "2020-09-30T04:08:00.000Z", endTime: "2020-10-17T05:08:00.000Z", eventTitle: "標題21", remark: "一點備註", eventColor: "#38ffff")
        let e18 = TestModel(id: "18", startTime: "2020-10-30T04:08:00.000Z", endTime: "2020-11-02T05:08:00.000Z", eventTitle: "標題22", remark: "一點備註", eventColor: "#38ffff")
        
        var events: [TestModel] = []
        events.append(contentsOf: [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e18, e17])
        return events
    }
    
    static func getHolidays() -> [HolidayModel] {
        let e1 = HolidayModel(id: 20, time: "2020-10-16T04:08:00.000Z", holodayTitle: "測假日")
        let e2 = HolidayModel(id: 22, time: "2020-04-11T04:08:00.000Z", holodayTitle: "假日二")
        let e3 = HolidayModel(id: 23, time: "2020-10-12T04:08:00.000Z", holodayTitle: "假日三")
        let e4 = HolidayModel(id: 24, time: "2020-04-18T04:08:00.000Z", holodayTitle: "假日4")
        let e5 = HolidayModel(id: 25, time: "2020-10-20T04:08:00.000Z", holodayTitle: "假日5")
        
        var holidays: [HolidayModel] = []
        holidays.append(contentsOf: [e1, e2, e3, e4, e5])
        return holidays
    }
}

struct TestModel: Codable, CalendarEvent {
    var id: String
    var startTime: String?
    var endTime: String?
    var eventTitle: String?
    var remark: String?
    var eventColor: String?
    var allDay: Bool? = false
    var attendee: [Int]?
    var location: String?
    var notifyTimeConfig: [Bool]?
    var createTime: String?
    
    var startDateTime: String {
        return startTime ?? ""
    }
    var endDateTime: String {
        return endTime ?? ""
    }
    var color: String {
        return eventColor ?? "#000000"
    }
    var title: String {
        return eventTitle ?? ""
    }
    var isAllDay: Bool {
        return allDay ?? false
    }
    var isAlert: Bool {
        return (notifyTimeConfig?.count ?? 0) > 0
    }
    var eventId: String? {
        return id
    }
    var isJoin: Bool {
        var result = false
        let me = 0
        if let filter = attendee?.filter({ $0 == me }) {
            result = filter.count > 0
        }
        return result
    }
    var name: String? {
        return "name"
    }
    var style: DayEvent.Style? {
        return nil
    }
}

struct HolidayModel: Codable, CalendarEvent {
    public var id: Int?
    public var time: String?
    public var holodayTitle: String?
    
    var startDateTime: String {
        return time ?? ""
    }
    var endDateTime: String {
        return time ?? ""
    }
    var color: String {
        return "#d65757"
    }
    var title: String {
        return holodayTitle ?? ""
    }
    var isAllDay: Bool {
        return true
    }
    var isAlert: Bool {
        return false
    }
    var eventId: String? {
        if let id = id {
            return String(id)
        } else {
            return nil
        }
    }
    var isJoin: Bool {
        return false
    }
    var name: String? {
        return holodayTitle
    }
    var style: DayEvent.Style? {
        return .holiday
    }
}
