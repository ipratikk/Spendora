//
//  PeriodFilter.swift
//  SharedModels
//

import Foundation

public enum PeriodFilter: String, CaseIterable, Identifiable {
    case all
    case week       // This Week
    case lastWeek   // Last Week
    case month
    case quarter
    case year
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .all: return "All"
        case .week: return "This Week"
        case .lastWeek: return "Last Week"
        case .month: return "Month"
        case .quarter: return "Quarter"
        case .year: return "Year"
        }
    }
    
    /// Returns true if the given `date` falls in the selected period.
    public func matches(_ date: Date, now: Date = Date(), calendar: Calendar = .current) -> Bool {
        switch self {
        case .all:
            return true
            
        case .week:
            return calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) &&
            calendar.isDate(date, equalTo: now, toGranularity: .year)
            
        case .lastWeek:
            guard let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: now) else { return false }
            return calendar.isDate(date, equalTo: lastWeek, toGranularity: .weekOfYear) &&
            calendar.isDate(date, equalTo: lastWeek, toGranularity: .year)
            
        case .month:
            return calendar.isDate(date, equalTo: now, toGranularity: .month)
            
        case .quarter:
            guard
                let month = calendar.dateComponents([.month], from: date).month,
                let nowMonth = calendar.dateComponents([.month], from: now).month
            else { return false }
            
            let quarter = (month - 1) / 3
            let currentQuarter = (nowMonth - 1) / 3
            return quarter == currentQuarter &&
            calendar.isDate(date, equalTo: now, toGranularity: .year)
            
        case .year:
            return calendar.isDate(date, equalTo: now, toGranularity: .year)
        }
    }
}
