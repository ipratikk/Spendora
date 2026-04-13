//
//  SpendCategoryChart.swift
//  MannKiBaat
//

import SwiftUI
import Charts
import SharedModels

public struct SpendCategoryChart: View {
    let spends: [Spend]
    @Binding var selectedCategory: SpendCategory?
    
    @StateObject private var currencySync = CurrencySyncService.shared
    private let service = SpendsService.shared
    
    public init(spends: [Spend], selectedCategory: Binding<SpendCategory?>) {
        self.spends = spends
        self._selectedCategory = selectedCategory
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            let symbol = CurrencyCache.shared.symbol(for: currencySync.displayCurrency)
            Text("Category Breakdown (\(symbol))")
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.bottom, 4)
            
            let data = service.categoryTotals(from: spends)
                .sorted { lhs, rhs in
                    // Sort by category name for stability
                    (lhs.0?.name ?? "") < (rhs.0?.name ?? "")
                }
            
            if data.isEmpty {
                Text("No data available")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Chart {
                    ForEach(data, id: \.0?.id) { pair in
                        SectorMark(
                            angle: .value("Amount", pair.1),
                            innerRadius: .ratio(0.5),
                            angularInset: 1.5
                        )
                        .foregroundStyle(pair.0?.color ?? .gray)
                        .opacity(selectedCategory == nil || selectedCategory == pair.0 ? 1.0 : 0.3)
                    }
                }
                .chartLegend(position: .bottom) {
                    ForEach(data, id: \.0?.id) { pair in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(pair.0?.color ?? .gray)
                                .frame(width: 8, height: 8)
                            
                            Text(pair.0?.name ?? "Unknown")
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .appChartStyle()
                .frame(height: 220)
            }
        }
        .padding(.horizontal)
    }
}
