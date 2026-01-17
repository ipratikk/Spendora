//
//  SpendTrendChart.swift
//  MannKiBaat
//

import SwiftUI
import Charts
import SharedModels

public struct SpendTrendChart: View {
    let spends: [Spend]
    @Binding var selectedPeriod: PeriodFilter
    @Binding var selectedMonthKey: String?
    
    @StateObject private var currencySync = CurrencySyncService.shared
    private let service = SpendsService.shared
    
    public init(
        spends: [Spend],
        selectedPeriod: Binding<PeriodFilter>,
        selectedMonthKey: Binding<String?>
    ) {
        self.spends = spends
        self._selectedPeriod = selectedPeriod
        self._selectedMonthKey = selectedMonthKey
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            let symbol = CurrencyCache.shared.symbol(for: currencySync.displayCurrency)
            Text("Monthly Trend (\(symbol))")
                .font(.headline)
                .padding(.bottom, 4)
            
            let raw = service.monthlyTotals(from: spends)
            let data = raw.map { TrendPoint(month: $0.0, amount: $0.1) }
            
            if data.isEmpty {
                Text("No data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Chart(data) { point in
                    BarMark(
                        x: .value("Month", point.month),
                        y: .value("Amount", point.amount)
                    )
                    .foregroundStyle(
                        selectedMonthKey == point.month ? .orange : .blue
                    )
                }
                .chartYAxisLabel(position: .trailing) {
                    Text(symbol)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(height: 220)
            }
        }
        .padding(.horizontal)
    }
    
    private struct TrendPoint: Identifiable {
        let month: String
        let amount: Double
        var id: String { month }
    }
}
