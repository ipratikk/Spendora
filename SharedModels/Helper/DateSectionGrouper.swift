//
//  DateSectionGrouper.swift
//  SharedModels
//

import Foundation

public enum DateSectionGrouper {
    /// Returns a section title for a given date
    public static func sectionTitle(for date: Date, now: Date = Date(), calendar: Calendar = .current) -> String {
        if date.isToday(using: calendar) { return "Today" }
        if date.isYesterday(using: calendar) { return "Yesterday" }
        
        // This Week
        if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) &&
            calendar.isDate(date, equalTo: now, toGranularity: .year) {
            return "This Week"
        }
        
        // Last Week
        if let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: now),
           calendar.isDate(date, equalTo: lastWeek, toGranularity: .weekOfYear),
           calendar.isDate(date, equalTo: lastWeek, toGranularity: .year) {
            return "Last Week"
        }
        
        // Last 30 Days
        if let daysAgo = date.daysAgo(from: now, using: calendar), daysAgo <= 30 {
            return "Last 30 Days"
        }
        
        // Same Year → group by month
        if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
            return date.monthYearString()
        }
        
        // Fallback → group by year
        return date.yearString()
    }
    
    /// Sorts section headers in human-friendly order
    public static func sectionSort(_ a: String, _ b: String) -> Bool {
        let fixedOrder: [String] = ["Today", "Yesterday", "This Week", "Last Week", "Last 30 Days"]
        
        if fixedOrder.contains(a), fixedOrder.contains(b) {
            return fixedOrder.firstIndex(of: a)! < fixedOrder.firstIndex(of: b)!
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        // Try parsing as month-year
        if let dateA = formatter.date(from: a), let dateB = formatter.date(from: b) {
            return dateA > dateB
        }
        
        // Try parsing as year
        if let yearA = Int(a), let yearB = Int(b) {
            return yearA > yearB
        }
        
        // Fallback lexicographic
        return a > b
    }
}
