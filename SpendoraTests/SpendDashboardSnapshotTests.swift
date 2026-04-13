//
//  SpendDashboardSnapshotTests.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/26.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Spendora
internal import SwiftData
import SharedModels
import LoginFeature

@MainActor
final class SpendDashboardSnapshotTests: XCTestCase {
    
    let record = false
    
    private func makeMockContainer() -> ModelContainer {
        ModelContainer.mock
    }
    
    private func mockSpends(from container: ModelContainer) -> [Spend] {
        let context = container.mainContext
        return (try? context.fetch(FetchDescriptor<Spend>())) ?? []
    }
    
    func test_dashboard_snapshot_initial() {
        let container = makeMockContainer()
        let view = SpendDashboardView()
            .modelContainer(container)
        
        verifySnapshots(
            view,
            record: record
        )
    }
    
    func test_add_expense_screen() {
        let container = makeMockContainer()
        let spends = mockSpends(from: container)
        let category = spends.first(where: { $0.category?.name.lowercased() == "food" })?.category
        
        let view = AddSpendView(
            title: "Coffee",
            detail: "Morning coffee",
            amount: "250",
            currency: "INR",
            selectedCategory: category
        )
            .modelContainer(container)
        
        verifySnapshots(
            view,
            record: record
        )
    }
    
    func test_category_summary_screen() {
        let container = makeMockContainer()
        let view = CategoryListView()
            .modelContainer(container)
        
        verifySnapshots(
            view,
            record: record
        )
    }
    
    func test_category_chart() {
        let container = makeMockContainer()
        let spends = mockSpends(from: container)
        
        let view = SpendCategoryChart(
            spends: spends,
            selectedCategory: .constant(nil)
        )
            .modelContainer(container)
        
        verifySnapshots(
            view,
            record: record
        )
    }
    
    func test_trend_chart() {
        let container = makeMockContainer()
        let spends = mockSpends(from: container)
        
        let view = SpendTrendChart(
            spends: spends,
            selectedPeriod: .constant(.all),
            selectedMonthKey: .constant(nil)
        )
            .modelContainer(container)
        
        verifySnapshots(
            view,
            record: record
        )
    }
    
    func test_analysis_view() {
        let container = makeMockContainer()
        let view = SpendAnalysisView()
            .modelContainer(container)
        
        verifySnapshots(
            view,
            record: record
        )
    }
    
    func test_login_screen() {
        let namespace = Namespace().wrappedValue
        
        let view = LoginView(
            viewModel: LoginViewModel(),
            namespace: namespace,
            showContent: .constant(true)
        )
        
        verifySnapshots(
            view,
            record: record
        )
    }
}
