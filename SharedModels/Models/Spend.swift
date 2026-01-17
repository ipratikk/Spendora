//
//  Spend.swift
//  SharedModels
//

import SwiftData
import Foundation

@Model
public class Spend {
    public var id: UUID = UUID()
    public var title: String = ""
    public var detail: String? = nil
    public var amount: Double = 0.0
    public var currency: String = "INR"
    public var date: Date = Date()
    public var exchangeRateToINR: Double = 1.0
    
    public var category: SpendCategory?
    public var receiptImageDatas: [Data]?
    
    public init(
        title: String,
        detail: String? = nil,
        amount: Double,
        currency: String,
        date: Date,
        category: SpendCategory?,
        receiptImageDatas: [Data]? = nil,
        exchangeRateToINR: Double = 1.0
    ) {
        self.id = UUID()
        self.title = title
        self.detail = detail
        self.amount = amount
        self.currency = currency
        self.date = date
        self.category = category
        self.receiptImageDatas = receiptImageDatas
        self.exchangeRateToINR = exchangeRateToINR
    }
}

public extension Spend {
    /// Always returns a non-optional receipts array
    var safeReceipts: [Data] {
        get { receiptImageDatas ?? [] }
        set { receiptImageDatas = newValue }
    }
}
