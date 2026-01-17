//
//  CurrencySyncService.swift
//  SharedModels
//

import SwiftUI
import Combine

@MainActor
public final class CurrencySyncService: ObservableObject {
    public static let shared = CurrencySyncService()
    private init() {}
    
    // Budget definition (amount + currency + period)
    @AppStorage("budgetAmount") public var budgetAmount: Double = 0 { didSet { objectWillChange.send() } }
    @AppStorage("budgetCurrency") public var budgetCurrency: String = "INR" { didSet { objectWillChange.send() } }
    @AppStorage("budgetPeriod") public var budgetPeriodRaw: String = PeriodFilter.month.rawValue { didSet { objectWillChange.send() } }
    
    // Display currency (UI only)
    @AppStorage("displayCurrency") public var displayCurrency: String = "INR" { didSet { objectWillChange.send() } }
    
    public var budgetPeriod: PeriodFilter { PeriodFilter(rawValue: budgetPeriodRaw) ?? .month }
    
    // MARK: - Display Currency (toolbar / charts only)
    public func updateDisplayCurrency(to newValue: String) {
        guard displayCurrency != newValue else { return }
        displayCurrency = newValue
        objectWillChange.send()
    }
    
    // MARK: - Update Budget (via BudgetSettingsView)
    public func updateBudget(amount: Double, period: PeriodFilter, currency: String) {
        budgetAmount = amount
        budgetPeriodRaw = period.rawValue
        budgetCurrency = currency
        // When user sets budget, also align display currency with it
        displayCurrency = currency
        objectWillChange.send()
    }
    
    // MARK: - Helpers
    public func convertedValue(_ value: Double, from oldCurrency: String, to newCurrency: String) -> Double {
        guard oldCurrency != newCurrency else { return value }
        if oldCurrency == "INR" && newCurrency == "USD" {
            return value / CurrencyCache.shared.usdToInrRate
        } else if oldCurrency == "USD" && newCurrency == "INR" {
            return value * CurrencyCache.shared.usdToInrRate
        } else {
            return value
        }
    }
}
