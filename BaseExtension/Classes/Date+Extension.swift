//
//  Date+Extension.swift
//  BaseExtension
//
//  Created by wade.hawk on 2018. 3. 2..
//

import Foundation

extension Date {
    public func dateString(dateFormat: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    public static func dateAt(string: String, dateFormat: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.date(from: string)
    }
    public func toLocalTime() -> Date {
        let timezone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: TimeInterval = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
