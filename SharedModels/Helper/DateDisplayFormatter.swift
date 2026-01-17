//
//  DateDisplayFormatter.swift
//  SharedModels
//

import Foundation

public enum DateDisplayFormatter {
    /// Compact date for row-level display
    public static func formattedRowDate(
        _ date: Date,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> String {
        if calendar.isDateInToday(date) || calendar.isDateInYesterday(date) {
            return date.timeString()
        }
        if let days = date.daysAgo(from: now, using: calendar), days <= 30 {
            return date.dayMonthYearString()
        }
        if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) &&
            calendar.isDate(date, equalTo: now, toGranularity: .year) {
            return "This Week"
        }
        if let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: now),
           calendar.isDate(date, equalTo: lastWeek, toGranularity: .weekOfYear),
           calendar.isDate(date, equalTo: lastWeek, toGranularity: .year) {
            return "Last Week"
        }
        if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
            return date.monthYearString()
        }
        return date.yearString()
    }
    
    /// Longer descriptive version (for details)
    public static func formattedDetailDate(
        _ date: Date,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> String {
        if calendar.isDateInToday(date) {
            return "Today at \(date.timeString())"
        }
        if calendar.isDateInYesterday(date) {
            return "Yesterday at \(date.timeString())"
        }
        if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) &&
            calendar.isDate(date, equalTo: now, toGranularity: .year) {
            return "This Week (\(date.weekRangeString(using: calendar)))"
        }
        if let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: now),
           calendar.isDate(date, equalTo: lastWeek, toGranularity: .weekOfYear),
           calendar.isDate(date, equalTo: lastWeek, toGranularity: .year) {
            return "Last Week (\(date.weekRangeString(using: calendar)))"
        }
        if let days = date.daysAgo(from: now, using: calendar), days <= 30 {
            return date.dayMonthYearString() + " at \(date.timeString())"
        }
        if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
            return date.dayMonthYearString()
        }
        return date.monthYearString() + " " + date.yearString()
    }
}
