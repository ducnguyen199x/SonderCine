//
//  Date+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

extension Date {
    static func today() -> Date {
        Date().startOfDay()
    }
    
    static func now() -> Date {
        return Date()
    }
    
    func startOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self).addingTimeInterval(86399)
    }
}

extension Date {
    func timeStringFromNow() -> String {
        let now = Date()
        let day = daysDiffer(to: now)
        if day == 0 {
            return dateString(format: .format4)
        }
        if day == 1 {
            return "Yesterday"
        }
        return "\(day) days ago"
    }
    
    func daysDiffer(to date: Date) -> Int {
        return components(units: [.day], to: date).day ?? 0
    }
    
    func components(_ components: Set<Calendar.Component> = [.hour, .minute]) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents(components, from: self)
    }
    
    func components(units: NSCalendar.Unit, to date: Date) -> DateComponents {
        let calendar = Calendar.current
        return (calendar as NSCalendar).components(units, from: self, to: date, options: [])
    }
    
    func dateString(format: DateFormatter) -> String {
        return format.string(from: self)
    }
    
    func addingDays(_ days: Int) -> Date {
        return addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
    }
}
