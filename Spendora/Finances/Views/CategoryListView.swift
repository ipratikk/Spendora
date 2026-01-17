//
//  CategoryListView.swift
//  SpendsFeature
//

import SwiftUI
import SharedModels
import SwiftData

@MainActor
public struct CategoryListView: View {
    @Query(sort: \SpendCategory.name) private var categories: [SpendCategory]
    @Environment(\.modelContext) private var modelContext
    
    @State private var newCategoryName: String = ""
    @State private var newCategoryIcon: String = "tag"
    
    public init() {}
    
    public var body: some View {
        ZStack {
            GradientBackgroundView()
            
            NavigationStack {
                List {
                    Section("Existing Categories") {
                        ForEach(categories) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.name)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { i in
                                let categoryToDelete = categories[i]
                                CategoryService.deleteCategory(categoryToDelete, in: modelContext)
                            }
                        }
                    }
                    
                    Section("Add New Category") {
                        TextField("Category Name", text: $newCategoryName)
                            .textInputAutocapitalization(.words)
                        TextField("Icon (SF Symbol)", text: $newCategoryIcon)
                        
                        Button {
                            guard !newCategoryName.isEmpty else { return }
                            let category = SpendCategory(
                                name: newCategoryName,
                                icon: newCategoryIcon.isEmpty ? "tag" : newCategoryIcon
                            )
                            modelContext.insert(category)
                            try? modelContext.save()
                            newCategoryName = ""
                            newCategoryIcon = "tag"
                        } label: {
                            Label("Add Category", systemImage: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .navigationTitle("Categories")
                .scrollContentBackground(.hidden) // ✅ gradient visible
            }
        }
    }
}
