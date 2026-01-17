//
//  SpendCategory.swift
//  SharedModels
//

import SwiftData
import Foundation

@Model
public final class SpendCategory: Identifiable, Equatable, Hashable {
    public var id: UUID = UUID()
    public var name: String = ""
    public var icon: String = "tag"
    
    @Relationship(inverse: \Spend.category)
    public var spends: [Spend]?
    
    // MARK: - Init
    public init(id: UUID = UUID(), name: String = "", icon: String = "tag") {
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    // MARK: - Equatable
    public static func == (lhs: SpendCategory, rhs: SpendCategory) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
