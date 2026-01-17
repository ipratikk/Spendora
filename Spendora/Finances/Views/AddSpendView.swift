//
//  AddSpendView.swift
//  SpendsFeature
//

import SwiftUI
import SwiftData
import SharedModels

@MainActor
public struct AddSpendView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \SpendCategory.name) private var categories: [SpendCategory]
    
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var amount: String = ""
    @State private var currency: String = "INR"
    @State private var date: Date = Date()
    @State private var selectedCategory: SpendCategory?
    @State private var receiptImages: [Data] = []   // ✅ use this for new spends
    
    private let service = SpendsService.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView()
                
                Form {
                    Section("Title & Detail") {
                        TextField("Title", text: $title)
                        TextField("Detail (optional)", text: $detail, axis: .vertical)
                            .lineLimit(1...)
                    }
                    
                    Section("Amount") {
                        TextField("Enter amount", text: $amount)
                            .keyboardType(.decimalPad)
                        Picker("Currency", selection: $currency) {
                            Text("INR").tag("INR")
                            Text("USD").tag("USD")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("Category") {
                        Picker("Select Category", selection: $selectedCategory) {
                            ForEach(categories) { category in
                                Text(category.name).tag(Optional(category))
                            }
                        }
                    }
                    
                    Section("Date") {
                        DatePicker("Transaction Date", selection: $date, displayedComponents: .date)
                    }
                    
                    AttachmentCarousel(
                        title: "Receipts",
                        attachments: $receiptImages,
                        addLabel: "Add Receipt",
                        usePolaroidStyle: false,
                        tapStyle: .viewer
                    )
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add Spend")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { Task { await saveSpend() } }
                        .disabled(!service.isValidInput(title: title, amount: amount))
                }
            }
        }
    }
    
    private func saveSpend() async {
        guard service.isValidInput(title: title, amount: amount) else { return }
        
        let category = selectedCategory ?? CategoryService.fetchOrCreateOthersCategory(in: modelContext)
        let rate: Double = (currency == "INR") ? 1.0 : CurrencyCache.shared.usdToInrRate
        
        let spend = Spend(
            title: title.trimmingCharacters(in: .whitespaces),
            detail: detail.isEmpty ? nil : detail,
            amount: Double(amount) ?? 0,
            currency: currency,
            date: date,
            category: category,
            receiptImageDatas: receiptImages,   // ✅ save attachments here
            exchangeRateToINR: rate
        )
        
        modelContext.insert(spend)
        try? modelContext.save()
        dismiss()
    }
}
