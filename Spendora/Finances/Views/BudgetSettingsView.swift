//
//  BudgetSettingsView.swift
//  SpendsFeature
//

import SwiftUI
import SharedModels

public struct BudgetSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var currencySync = CurrencySyncService.shared
    
    @State private var inputAmount: String = ""
    @State private var tempCurrency: String = "INR"
    
    public init() {}
    
    public var body: some View {
        ZStack {
            GradientBackgroundView()
            
            NavigationStack {
                Form {
                    // MARK: Budget Amount + Currency
                    Section("Budget Amount") {
                        HStack {
                            TextField("Enter amount", text: $inputAmount)
                                .keyboardType(.decimalPad)
                            
                            Picker("Currency", selection: $tempCurrency) {
                                Text("INR").tag("INR")
                                Text("USD").tag("USD")
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 120)
                            .onChange(of: tempCurrency) { newValue in
                                guard let current = Double(inputAmount), current > 0 else {
                                    currencySync.updateDisplayCurrency(to: newValue)
                                    return
                                }
                                let converted = currencySync.convertedValue(
                                    current,
                                    from: currencySync.budgetCurrency,
                                    to: newValue
                                )
                                inputAmount = String(format: "%.0f", converted)
                                currencySync.updateDisplayCurrency(to: newValue)
                            }
                        }
                    }
                    
                    // MARK: Budget Period
                    Section("Budget Period") {
                        Picker("Period", selection: $currencySync.budgetPeriodRaw) {
                            ForEach([PeriodFilter.week, .month, .quarter, .year], id: \.self) { filter in
                                Text(filter.displayName).tag(filter.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .navigationTitle("Budget Settings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            let amount = Double(inputAmount) ?? 0
                            let period = PeriodFilter(rawValue: currencySync.budgetPeriodRaw) ?? .month
                            currencySync.updateBudget(amount: amount,
                                                      period: period,
                                                      currency: tempCurrency)
                            dismiss()
                        }
                    }
                }
                .onAppear {
                    tempCurrency = currencySync.budgetCurrency
                    inputAmount = currencySync.budgetAmount > 0 ? "\(Int(currencySync.budgetAmount))" : ""
                }
                .scrollContentBackground(.hidden) // ✅ gradient visible
            }
        }
    }
}
