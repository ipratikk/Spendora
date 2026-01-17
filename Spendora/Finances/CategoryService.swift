//
//  CategoryService.swift
//  SharedModels
//

import SwiftData
import SharedModels

public enum CategoryService {
    @MainActor
    public static func addCategory(name: String, icon: String, in context: ModelContext) {
        let category = SpendCategory(name: name, icon: icon)
        context.insert(category)
        try? context.save()
    }
    
    @MainActor
    public static func deleteCategory(_ category: SpendCategory, in context: ModelContext) {
        // Move spends to Others if any
        if let others = fetchOrCreateOthersCategory(in: context), let spends = category.spends {
            for spend in spends { spend.category = others }
        }
        context.delete(category)
        try? context.save()
    }
    
    @MainActor
    public static func fetchOrCreateOthersCategory(in context: ModelContext) -> SpendCategory? {
        if let existing = (try? context.fetch(FetchDescriptor<SpendCategory>()))?.first(where: { $0.name == "Others" }) {
            return existing
        }
        let others = SpendCategory(name: "Others", icon: "ellipsis.circle")
        context.insert(others)
        try? context.save()
        return others
    }
}
