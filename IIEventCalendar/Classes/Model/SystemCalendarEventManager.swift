//
//  SystemCalendarEventManager.swift
//  EventCalendar
//
//  Created by ice on 2020/8/10.
//  Copyright © 2020 iceboxidev. All rights reserved.
//

import Foundation
import EventKit

class SystemCalendarEventManager {
    static let shared = SystemCalendarEventManager()
    private var eventStore = EKEventStore()
    
    private init() {
        
    }
    
    func authorizationAndFetchEventsFromCalendar() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch status {
        case .notDetermined:
            requestAccessToCalendar()
        case .authorized:
            self.fetchEventsFromCalendar()
        case .restricted, .denied: break
        @unknown default:
            fatalError()
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event) { [unowned self] (_, _) in
            self.fetchEventsFromCalendar()
        }
    }
    
    // MARK: Fetech Events from Calendar
    func fetchEventsFromCalendar() {
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            let selectedCalendar = calendar
            let startDate = NSDate(timeIntervalSinceNow: -60*60*24*180)
            let endDate = NSDate(timeIntervalSinceNow: 60*60*24*180)
            let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [selectedCalendar])
            let events = eventStore.events(matching: predicate)
            
            for event in events {
                print(event.title ?? "-")
            }
        }
    }
    
    func addEvent(with model: CalendarEvent) {
        let event = EKEvent(eventStore: eventStore)
        event.title = model.title
        event.startDate = model.startDateTime.toLocalDate()
        event.endDate = model.endDateTime.toLocalDate()
//        ekEvent.alarms = [EKAlarm(relativeOffset: -60 * 10)] // 待處理轉換
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            // TODO: i store id
            _ = event.eventIdentifier
        } catch {
            print(error)
        }
    }
    
    func editEvent(_ id: String) {
        guard let event = eventStore.event(withIdentifier: id) else { return }
        // TODO: i modify
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print(error)
        }
    }
    
    func removeEvent(_ id: String) {
        guard let event = eventStore.event(withIdentifier: id) else { return }
        
        do {
            try eventStore.remove(event, span: .thisEvent)
        } catch {
            print(error)
        }
        
    }
    
    // TODO: i 轉換ekevent <-> tuevent
}
