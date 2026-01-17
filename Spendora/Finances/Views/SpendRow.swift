//
//  SpendRow.swift
//  SpendsFeature
//

import SwiftUI
import SharedModels

@MainActor
public struct SpendRow: View {
    let spend: Spend
    let section: String
    
    public init(spend: Spend, section: String) {
        self.spend = spend
        self.section = section
    }
    
    public var body: some View {
        HStack {
            if let category = spend.category {
                Image(systemName: category.icon)
                    .foregroundColor(.accentColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(spend.title)
                    .font(.headline)
                if let detail = spend.detail, !detail.isEmpty {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Text(DateDisplayFormatter.formattedRowDate(spend.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(CurrencyCache.format(spend.amount, currency: spend.currency))
                    .bold()
                // 📎 indicator if receipts exist
                if !spend.safeReceipts.isEmpty {
                    Image(systemName: "paperclip")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
