//
//  FilterPills.swift
//  SpendsFeature
//

import SwiftUI
import SharedModels

public struct FilterPills: View {
    let categories: [SpendCategory]
    @Binding var selectedCategory: SpendCategory?
    @Binding var selectedPeriod: PeriodFilter
    @Binding var selectedMonthKey: String?
    
    public init(
        categories: [SpendCategory],
        selectedCategory: Binding<SpendCategory?>,
        selectedPeriod: Binding<PeriodFilter>,
        selectedMonthKey: Binding<String?>
    ) {
        self.categories = categories
        self._selectedCategory = selectedCategory
        self._selectedPeriod = selectedPeriod
        self._selectedMonthKey = selectedMonthKey
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Category pills
                ForEach(categories) { category in
                    PillButton(
                        text: category.name,
                        isSelected: selectedCategory == category
                    ) {
                        if selectedCategory == category {
                            selectedCategory = nil
                        } else {
                            selectedCategory = category
                        }
                    }
                }
                
                // Period filter pills
                ForEach([PeriodFilter.all, .month, .quarter, .year], id: \.self) { period in
                    PillButton(
                        text: period.displayName,
                        isSelected: selectedPeriod == period
                    ) {
                        selectedPeriod = period
                        selectedMonthKey = nil // reset month filter
                    }
                }
                
                // Month pills (dummy list for now; you can pass in service.uniqueMonths if needed)
                if let spends = try? categories.first?.spends { // placeholder: you may pass spends externally
                    let months = Array(Set(spends.map { DateFormatter.shortMonthYear.string(from: $0.date) } ?? []))
                    ForEach(months, id: \.self) { month in
                        PillButton(
                            text: month,
                            isSelected: selectedMonthKey == month
                        ) {
                            if selectedMonthKey == month {
                                selectedMonthKey = nil
                            } else {
                                selectedMonthKey = month
                                selectedPeriod = .month
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
}

// MARK: - PillButton

fileprivate struct PillButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.15))
                .foregroundColor(isSelected ? .accentColor : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Helper DateFormatter for months

fileprivate extension DateFormatter {
    static let shortMonthYear: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM yy"
        return df
    }()
}
