//
//  MockData.swift
//  Spendora
//
//  Created by Pratik Goel on 14/04/26.
//

import Foundation

struct MockData: Decodable {
    let categories: [MockCategory]
    let spends: [MockSpend]
}

struct MockCategory: Decodable {
    let id: String
    let name: String
    let icon: String
}

struct MockSpend: Decodable {
    let title: String
    let detail: String
    let amount: Double
    let currency: String
    let date: Date
    let categoryId: String
    let exchangeRateToINR: Double
}
