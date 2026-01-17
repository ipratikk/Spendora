//
//  RatesResponse.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 16/09/25.
//


import Foundation

public func fetchExchangeRate(for currency: String, on date: Date) async -> Double {
    guard currency == "USD" else { return 1.0 }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    
    guard let url = URL(string: "https://api.exchangerate.host/\(dateString)?base=USD&symbols=INR") else {
        return 1.0
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(RatesResponse.self, from: data)
        return decoded.rates["INR"] ?? 1.0
    } catch {
        print("Exchange rate fetch failed: \(error)")
        return 1.0
    }
}

private struct RatesResponse: Decodable {
    let rates: [String: Double]
}
