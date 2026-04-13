//
//  SpendCategory.swift
//  SharedModels
//

import SwiftData
import Foundation
import SwiftUI

@Model
public final class SpendCategory: Identifiable, Equatable, Hashable {
    public var id: UUID = UUID()
    public var name: String = ""
    public var icon: String = "tag"
    
    public var color: Color {
        switch name.lowercased() {
        case "food": return .green
        case "travel": return .blue
        case "shopping": return .orange
        case "health": return .red
        case "entertainment": return .purple
        default: return .gray
        }
    }
    
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
