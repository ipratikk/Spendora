//
//  CurrencyCache.swift
//  SharedModels
//

import Foundation
import SwiftUI
import SwiftData
import SharedModels

@MainActor
public final class CurrencyCache {
    public static let shared = CurrencyCache()
    private init() {}
    
    @AppStorage("usdToInrRate") public var usdToInrRateValue: Double = 83.0
    @AppStorage("lastRateRefreshDate") private var lastRateRefreshDate: String = ""
    
    public var usdToInrRate: Double { usdToInrRateValue }
    
    // MARK: - Formatting / Conversion
    public static func format(_ value: Double, currency: String) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currency
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    public func convertFromINR(_ amountINR: Double, to currency: String) -> Double {
        switch currency {
        case "USD": return amountINR / usdToInrRate
        default: return amountINR
        }
    }
    
    public func convertBudget(_ budgetINR: Double, to currency: String) -> Double {
        convertFromINR(budgetINR, to: currency)
    }
    
    public func symbol(for currency: String) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currency
        return f.currencySymbol ?? currency
    }
    
    // MARK: - Exchange Rate Logic
    
    /// Refresh exchange rates if stale (max once per day),
    /// and update missing spends in the given context.
    public func refreshIfNeeded(in context: ModelContext) async {
        let today = Self.todayString()
        
        if lastRateRefreshDate != today {
            if let latestRate = await fetchUSDtoINRRate(), latestRate > 0 {
                usdToInrRateValue = latestRate
                lastRateRefreshDate = today
            }
        }
        
        // Update any spends missing a valid exchange rate
        let fetch = FetchDescriptor<Spend>()
        if let spends = try? context.fetch(fetch) {
            var updated = 0
            for spend in spends where spend.exchangeRateToINR <= 0 {
                spend.exchangeRateToINR = spend.currency == "INR" ? 1.0 : usdToInrRate
                updated += 1
            }
            if updated > 0 {
                try? context.save()
                BannerManager.shared.show(message: "💱 Updated exchange rates for \(updated) spend(s)")
            }
        }
    }
    
    /// Fetch live USD → INR rate from Frankfurter API
    private func fetchUSDtoINRRate() async -> Double? {
        let urlString = "https://api.frankfurter.app/latest?from=USD&to=INR"
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let rates = json["rates"] as? [String: Double],
               let rate = rates["INR"] {
                return rate
            }
        } catch {
            print("⚠️ Failed to fetch USD→INR rate: \(error)")
        }
        return nil
    }
    
    /// Helper to get a simple "yyyy-MM-dd" string for today
    private static func todayString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }
}
