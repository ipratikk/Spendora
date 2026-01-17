//
//  SpendAnalysisView.swift
//  SpendsFeature
//

import SwiftUI
import SwiftData
import SharedModels

@MainActor
public struct SpendAnalysisView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Spend.date, order: .reverse) private var spends: [Spend]
    
    @StateObject private var currencySync = CurrencySyncService.shared
    private let service = SpendsService.shared
    
    @State private var selectedCategory: SpendCategory?
    @State private var selectedPeriod: PeriodFilter = .all
    @State private var selectedMonthKey: String?
    
    public init() {}
    
    public var body: some View {
        ZStack {
            GradientBackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Totals
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Spends")
                            .font(.headline)
                        Text(service.totalSpendsFormatted(from: spends))
                            .font(.title).bold()
                        
                        if currencySync.budgetAmount > 0 {
                            Text(service.budgetLabel(from: spends))
                                .font(.caption)
                                .foregroundColor(service.budgetColor(from: spends))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Filters (pills)
                    FilterPills(
                        categories: fetchCategories(),
                        selectedCategory: $selectedCategory,
                        selectedPeriod: $selectedPeriod,
                        selectedMonthKey: $selectedMonthKey
                    )
                    .padding(.horizontal)
                    
                    // Category Chart
                    SpendCategoryChart(
                        spends: service.filteredSpends(
                            from: spends,
                            category: selectedCategory,
                            period: selectedPeriod,
                            monthKey: selectedMonthKey
                        ),
                        selectedCategory: $selectedCategory
                    )
                    
                    // Trend Chart
                    SpendTrendChart(
                        spends: service.filteredSpends(
                            from: spends,
                            category: selectedCategory,
                            period: selectedPeriod,
                            monthKey: selectedMonthKey
                        ),
                        selectedPeriod: $selectedPeriod,
                        selectedMonthKey: $selectedMonthKey
                    )
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Analysis")
        .toolbar { toolbarContent }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                Button("INR") { currencySync.updateDisplayCurrency(to: "INR") }
                Button("USD") { currencySync.updateDisplayCurrency(to: "USD") }
            } label: {
                Label(currencySync.displayCurrency, systemImage: "dollarsign.circle")
            }
        }
    }
    
    // MARK: - Helpers
    private func fetchCategories() -> [SpendCategory] {
        let descriptor = FetchDescriptor<SpendCategory>(sortBy: [SortDescriptor(\.name)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
