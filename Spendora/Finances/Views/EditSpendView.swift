//
//  EditSpendView.swift
//  SpendsFeature
//

import SwiftUI
import SwiftData
import SharedModels

@MainActor
public struct EditSpendView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var spend: Spend
    @Query(sort: \SpendCategory.name) private var categories: [SpendCategory]
    
    private let service = SpendsService.shared
    @State private var showDeleteAlert = false
    
    public init(spend: Spend) {
        self._spend = Bindable(wrappedValue: spend)
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView()
                
                Form {
                    Section("Title & Detail") {
                        TextField("Title", text: $spend.title)
                        TextField("Detail (optional)", text: Binding(
                            get: { spend.detail ?? "" },
                            set: { spend.detail = $0.isEmpty ? nil : $0 }
                        ), axis: .vertical)
                        .lineLimit(1...)
                    }
                    
                    Section("Amount") {
                        TextField("Enter amount", value: $spend.amount, format: .number)
                            .keyboardType(.decimalPad)
                        Text(spend.currency).foregroundColor(.secondary)
                    }
                    
                    Section("Category") {
                        Picker("Select Category", selection: $spend.category) {
                            ForEach(categories) { c in
                                Text(c.name).tag(Optional(c))
                            }
                        }
                    }
                    
                    Section("Date") {
                        DatePicker("Transaction Date", selection: $spend.date, displayedComponents: .date)
                    }
                    
                    AttachmentCarousel(
                        title: "Receipts",
                        attachments: $spend.safeReceipts,
                        addLabel: "Add Receipt",
                        usePolaroidStyle: false,
                        tapStyle: .viewer
                    )
                    
                    Section {
                        Button(role: .destructive) { showDeleteAlert = true } label: {
                            Label("Delete Spend", systemImage: "trash")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Spend")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        service.saveEdits(for: spend, in: modelContext)
                        dismiss()
                    }
                    .disabled(!service.isValidInput(title: spend.title, amount: "\(spend.amount)"))
                }
            }
            .alert("Delete Spend?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    service.deleteSpend(spend, in: modelContext)
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}
