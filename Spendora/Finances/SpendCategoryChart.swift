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
                .padding(.bottom, 4)
            
            let data = service.categoryTotals(from: spends)
            
            if data.isEmpty {
                Text("No data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Chart {
                    ForEach(data, id: \.0?.id) { pair in
                        SectorMark(
                            angle: .value("Amount", pair.1),
                            innerRadius: .ratio(0.5),
                            angularInset: 1.5
                        )
                        .foregroundStyle(
                            selectedCategory == nil || selectedCategory == pair.0
                            ? .blue
                            : .gray.opacity(0.3)
                        )
                    }
                }
                .chartLegend(.visible)
                .frame(height: 220)
            }
        }
        .padding(.horizontal)
    }
}
