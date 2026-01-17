//
//  SpendDashboardView.swift
//  SpendsFeature
//

import SwiftUI
import SwiftData
import SharedModels

@MainActor
public struct SpendDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Spend.date, order: .reverse) private var spends: [Spend]
    
    @State private var showAddSpend = false
    @State private var showBudgetSheet = false
    
    @StateObject private var currencySync = CurrencySyncService.shared
    private let service = SpendsService.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView()
                
                if spends.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "creditcard.trianglebadge.exclamationmark")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No spends yet — add your first one!")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    spendsList
                }
                
                plusButtonOverlay
            }
            .navigationTitle("Spends")
            .toolbar { toolbarContent }
            .sheet(isPresented: $showAddSpend) { AddSpendView() }
            .sheet(isPresented: $showBudgetSheet) { BudgetSettingsView() }
        }
    }
    
    // MARK: - List
    private var spendsList: some View {
        List {
            Section {
                header
                if currencySync.budgetAmount > 0 {
                    BudgetSection(spends: spends)
                }
            }
            
            ForEach(service.groupedSpends(spends), id: \.0) { section, items in
                Section(header: Text(section).font(.headline)) {
                    ForEach(items) { spend in
                        NavigationLink { EditSpendView(spend: spend) } label: {
                            SpendRow(spend: spend, section: section)
                        }
                    }
                    .onDelete { idx in
                        for i in idx { service.deleteSpend(items[i], in: modelContext) }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 4) {
            Text("Total Spends").font(.headline)
            Text(service.totalSpendsFormatted(from: spends))
                .font(.title).bold()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 8)
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
            
            Button { showBudgetSheet = true } label: {
                Image(systemName: "chart.pie")
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink { SpendAnalysisView() } label: {
                Image(systemName: "chart.bar")
            }
        }
    }
    
    // MARK: - Plus Button Overlay
    private var plusButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showAddSpend = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.buttonBackground)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        .scaleEffect(1.0)
                }
                .padding()
            }
        }
    }
}

fileprivate struct BudgetSection: View {
    let spends: [Spend]
    @StateObject private var currencySync = CurrencySyncService.shared
    private let service = SpendsService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Budget (\(currencySync.budgetPeriod.displayName))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(
                    CurrencyCache.format(
                        service.convertedBudgetAmount(),
                        currency: currencySync.displayCurrency
                    )
                )
                .font(.subheadline).bold()
            }
            ProgressView(value: service.budgetProgress(from: spends))
                .tint(service.budgetProgress(from: spends) > 1 ? .red : .blue)
            Text(
                "Used: " +
                CurrencyCache.format(
                    service.spentThisBudgetPeriod(from: spends),
                    currency: currencySync.displayCurrency
                ) +
                " / " +
                CurrencyCache.format(
                    service.convertedBudgetAmount(),
                    currency: currencySync.displayCurrency
                )
            )
            .font(.caption)
            .foregroundColor(service.budgetProgress(from: spends) > 1 ? .red : .secondary)
        }
        .padding(.vertical, 8)
    }
}
