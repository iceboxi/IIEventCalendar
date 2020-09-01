//
//  String+Extension.swift
//  EventCalendar
//
//  Created by ice on 2020/8/13.
//  Copyright © 2020 iceboxidev. All rights reserved.
//

import Foundation

extension String {
    func toLocalDateString(_ inputFormat: String, _ outputFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let localDate = dateFormatter.date(from: self) else { return nil }
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: localDate)
    }
    
    func toLocalDate() -> Date? {
        guard let localDateString = toLocalDateString(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        ) else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: localDateString)
    }
}
