//
//  ModelContainer+Mock.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/26.
//

import Foundation
import SwiftData
import SharedModels

extension ModelContainer {
    
    @MainActor
    static var mock: ModelContainer {
        let schema = Schema([
            Spend.self,
            SpendCategory.self
        ])
        
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        
        let container = try! ModelContainer(for: schema, configurations: [config])
        
        seedMockData(in: container)
        
        return container
    }
    
    @MainActor
    private static func seedMockData(in container: ModelContainer) {
        let context = container.mainContext
        
        let bundleCandidates: [Bundle] = [
            Bundle.main,
            Bundle(for: BundleToken.self)
        ]
        
        let url = bundleCandidates
            .compactMap { $0.url(forResource: "mock_spends", withExtension: "json") }
            .first
        
        guard let fileURL = url,
              let data = try? Data(contentsOf: fileURL) else {
            assertionFailure("Failed to load mock_spends.json from any bundle")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let mockData = try decoder.decode(MockData.self, from: data)
            
            // Insert categories
            let categoryMap = Dictionary(uniqueKeysWithValues: mockData.categories.map { category in
                let model = SpendCategory(name: category.name, icon: category.icon)
                context.insert(model)
                return (category.id, model)
            })
            
            // Insert spends
            for spend in mockData.spends {
                guard let category = categoryMap[spend.categoryId] else { continue }
                
                let model = Spend(
                    title: spend.title,
                    detail: spend.detail,
                    amount: spend.amount,
                    currency: spend.currency,
                    date: spend.date,
                    category: category,
                    receiptImageDatas: [],
                    exchangeRateToINR: spend.exchangeRateToINR
                )
                
                context.insert(model)
            }
            
            // No need to call save() for in-memory SwiftData during tests
            
        } catch {
            assertionFailure("Failed to decode mock JSON: \(error)")
        }
    }
    
    private static var fixedDate: Date {
        Date(timeIntervalSince1970: 1700000000)
    }
    private final class BundleToken {}
}
