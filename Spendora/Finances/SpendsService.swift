//
//  SpendsService.swift
//  SpendsFeature
//

import SwiftUI
import SwiftData
import Combine
import SharedModels

@MainActor
public final class SpendsService: ObservableObject {
    public static let shared = SpendsService()
    private init() {}
    
    @Published public var currencySync = CurrencySyncService.shared
    
    // MARK: - Validation
    public func isValidInput(title: String, amount: String) -> Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && (Double(amount) ?? 0) > 0
    }
    
    // MARK: - Add / Edit / Delete
    public func addSpend(
        title: String,
        detail: String?,
        amount: Double,
        currency: String,
        date: Date,
        category: SpendCategory?,
        receiptImageDatas: [Data],
        in context: ModelContext
    ) async {
        let rate: Double
        if currency == "INR" {
            rate = 1.0
        } else {
            await CurrencyCache.shared.refreshIfNeeded(in: context)
            rate = CurrencyCache.shared.usdToInrRate
        }
        
        let finalCategory = category ?? CategoryService.fetchOrCreateOthersCategory(in: context)
        
        let spend = Spend(
            title: title,
            detail: detail,
            amount: amount,
            currency: currency,
            date: date,
            category: finalCategory,
            receiptImageDatas: receiptImageDatas,
            exchangeRateToINR: rate
        )
        
        context.insert(spend)
        try? context.save()
    }
    
    public func saveEdits(for spend: Spend, in context: ModelContext) {
        if spend.category == nil {
            spend.category = CategoryService.fetchOrCreateOthersCategory(in: context)
        }
        try? context.save()
    }
    
    public func deleteSpend(_ spend: Spend, in context: ModelContext) {
        context.delete(spend)
        try? context.save()
    }
    
    // MARK: - Totals / Averages / Budget
    public func totalSpends(from spends: [Spend]) -> Double {
        let totalINR = spends.reduce(0.0) { $0 + ($1.amount * $1.exchangeRateToINR) }
        return CurrencyCache.shared.convertFromINR(totalINR, to: currencySync.displayCurrency)
    }
    
    public func totalSpendsFormatted(from spends: [Spend]) -> String {
        CurrencyCache.format(totalSpends(from: spends), currency: currencySync.displayCurrency)
    }
    
    public func averagePerDay(from spends: [Spend]) -> Double {
        guard let minDate = spends.map({ $0.date }).min(),
              let maxDate = spends.map({ $0.date }).max()
        else { return 0 }
        
        let days = max(Calendar.current.dateComponents([.day], from: minDate, to: maxDate).day ?? 0, 1)
        let avgINR = spends.reduce(0.0) { $0 + ($1.amount * $1.exchangeRateToINR) } / Double(days)
        return CurrencyCache.shared.convertFromINR(avgINR, to: currencySync.displayCurrency)
    }
    
    public func averagePerDayFormatted(from spends: [Spend]) -> String {
        CurrencyCache.format(averagePerDay(from: spends), currency: currencySync.displayCurrency)
    }
    
    public func convertedBudgetAmount() -> Double {
        let budgetInINR = currencySync.budgetCurrency == "USD"
        ? currencySync.budgetAmount * CurrencyCache.shared.usdToInrRate
        : currencySync.budgetAmount
        return CurrencyCache.shared.convertBudget(budgetInINR, to: currencySync.displayCurrency)
    }
    
    public func spentThisBudgetPeriod(from spends: [Spend]) -> Double {
        let totalINR = spends
            .filter { currencySync.budgetPeriod.matches($0.date) }
            .reduce(0.0) { $0 + ($1.amount * $1.exchangeRateToINR) }
        
        return CurrencyCache.shared.convertFromINR(totalINR, to: currencySync.displayCurrency)
    }
    
    public func budgetProgress(from spends: [Spend]) -> Double {
        let budget = convertedBudgetAmount()
        guard budget > 0 else { return 0 }
        return spentThisBudgetPeriod(from: spends) / budget
    }
    
    // MARK: - Grouping & Filtering
    public func groupedSpends(_ spends: [Spend]) -> [(String, [Spend])] {
        let grouped = Dictionary(grouping: spends) { DateSectionGrouper.sectionTitle(for: $0.date) }
        return grouped.map { ($0.key, $0.value) }.sorted { DateSectionGrouper.sectionSort($0.0, $1.0) }
    }
    
    public func filteredSpends(from spends: [Spend], category: SpendCategory?, period: PeriodFilter, monthKey: String?) -> [Spend] {
        spends.filter {
            var match = true
            if let cat = category { match = match && $0.category == cat }
            if period != .all { match = match && period.matches($0.date) }
            if let key = monthKey {
                let f = DateFormatter(); f.dateFormat = "MMM yy"
                match = match && (f.string(from: $0.date) == key)
            }
            return match
        }
    }
    
    public func uniqueMonths(from spends: [Spend]) -> [String] {
        let f = DateFormatter(); f.dateFormat = "MMM yy"
        return Array(Set(spends.map { f.string(from: $0.date) })).sorted()
    }
    
    // MARK: - Charts
    public func categoryTotals(from spends: [Spend]) -> [(SpendCategory?, Double)] {
        var totals: [SpendCategory?: Double] = [:]
        for s in spends {
            let amountINR = s.amount * s.exchangeRateToINR
            let converted = CurrencyCache.shared.convertFromINR(amountINR, to: currencySync.displayCurrency)
            totals[s.category, default: 0] += converted
        }
        return totals.map { ($0.key, $0.value) }
    }
    
    public func monthlyTotals(from spends: [Spend]) -> [(String, Double)] {
        let f = DateFormatter(); f.dateFormat = "MMM yy"
        var totals: [String: Double] = [:]
        for s in spends {
            let amountINR = s.amount * s.exchangeRateToINR
            let converted = CurrencyCache.shared.convertFromINR(amountINR, to: currencySync.displayCurrency)
            totals[f.string(from: s.date), default: 0] += converted
        }
        return totals.sorted { $0.0 < $1.0 }
    }
    
    // MARK: - Small helpers
    public func budgetLabel(from spends: [Spend]) -> String {
        guard currencySync.budgetAmount > 0 else { return "" }
        return "Budget: \(CurrencyCache.format(convertedBudgetAmount(), currency: currencySync.displayCurrency)) (\(currencySync.budgetPeriod.displayName))"
    }
    
    public func budgetColor(from spends: [Spend]) -> Color {
        guard convertedBudgetAmount() > 0 else { return .primary }
        return totalSpends(from: spends) > convertedBudgetAmount() ? .red : .green
    }
}
