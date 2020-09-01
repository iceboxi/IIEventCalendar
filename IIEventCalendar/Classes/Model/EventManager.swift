//
//  EventManager.swift
//  EventCalendar
//
//  Created by ice on 2020/8/14.
//  Copyright © 2020 iceboxidev. All rights reserved.
//

import Foundation

open class EventManager {
    public typealias DateRangeHandler = (start: Date, end: Date, complete: () -> Void)
    
    public enum Complete {
        case success, cache, failure
    }
    
    static let shared = EventManager()
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEvent(_:)), name: .eventUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCalendar(_:)), name: .refreshCalendar, object: nil)
    }
    
    internal var startDate = Date()
    internal var endDate = Date()
    public var dayEvents: [String: [DayEvent]] = [:]
    
    open func reset() {
        dayEvents.removeAll()
        startDate = Date()
        endDate = Date()
    }
    
    @objc open func updateEvent(_ notify: Notification) {
        print("Calendar Update Event")
    }
    
    @objc public func refreshCalendar(_ notify: Notification) {
        print("Calendar Refresh")
    }
    
    open func fetchCalendar(_ date: Date?, complete: ((Complete) -> Void)?) {
        fetchCalendar(date, end: date, complete: complete)
    }
    
    open func fetchCalendar(_ start: Date?, end: Date?, complete: ((Complete) -> Void)?) {
        guard let date = getRefechDate(start, end: end) else {
            complete?(.cache)
            return
        }
        
        date.complete()
        complete?(.success)
    }
    
    open func fetchHoliday(_ date: DateRangeHandler, complete: ((Complete) -> Void)?) {
        complete?(.success)
    }
    
    private func getRefechDate(_ start: Date?, end: Date?) -> DateRangeHandler? {
        var before = false
        var after = false
        if let start = start, startDate > start {
            before = true
        }
        if let end = end, end > endDate {
            after = true
        }
        
        if before, after {
            return (start!.startOfDay, end!.endOfDay, {
                self.startDate = start!
                self.endDate = end!
            })
        }
        
        if before {
            let date = startDate.dateByAddDays(-1)
            return (start!.startOfDay, date.endOfDay, {
                self.startDate = start!
            })
        } else if after {
            let date = endDate.dateByAddDays(1)
            return (date.startOfDay, end!.endOfDay, {
                self.endDate = end!
            })
        }
        
        return nil
    }
    
    func postEventUpdateComplete() {
        NotificationCenter.default.post(name: .eventUpdateComplete, object: nil, userInfo: nil)
    }
}

@objc enum APIStatus: Int {
    case none
    case start
    case success
    case error
    case noPermission
    case empty
}
