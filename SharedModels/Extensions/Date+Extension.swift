//
//  Date+Extension.swift
//  SharedModels
//

import Foundation

public extension Date {
    // MARK: - Relative Checks
    func isToday(using calendar: Calendar = .current) -> Bool {
        calendar.isDateInToday(self)
    }
    
    func isYesterday(using calendar: Calendar = .current) -> Bool {
        calendar.isDateInYesterday(self)
    }
    
    func daysAgo(from now: Date = Date(), using calendar: Calendar = .current) -> Int? {
        calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: self),
            to: calendar.startOfDay(for: now)
        ).day
    }
    
    // MARK: - String Formatting
    func timeString(locale: Locale = .current) -> String {
        let f = DateFormatter()
        f.locale = locale
        f.timeStyle = .short
        f.dateStyle = .none
        return f.string(from: self)
    }
    
    func dayMonthYearString(locale: Locale = .current) -> String {
        let f = DateFormatter()
        f.locale = locale
        f.dateStyle = .medium
        f.timeStyle = .none
        return f.string(from: self)
    }
    
    func monthYearString(locale: Locale = .current) -> String {
        let f = DateFormatter()
        f.locale = locale
        f.dateFormat = "MMMM yyyy"
        return f.string(from: self)
    }
    
    func yearString(locale: Locale = .current) -> String {
        let f = DateFormatter()
        f.locale = locale
        f.dateFormat = "yyyy"
        return f.string(from: self)
    }
    
    /// Week range string, e.g. "Sep 15 – Sep 21, 2025"
    func weekRangeString(using calendar: Calendar = .current, locale: Locale = .current) -> String {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: self) else {
            return self.dayMonthYearString(locale: locale)
        }
        let f = DateFormatter()
        f.locale = locale
        f.dateFormat = "MMM d"
        
        let start = f.string(from: weekInterval.start)
        let end = f.string(from: weekInterval.end.addingTimeInterval(-1)) // subtract 1 sec to stay in week
        let year = self.yearString(locale: locale)
        
        return "\(start) – \(end), \(year)"
    }
}
