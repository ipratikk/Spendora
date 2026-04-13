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

@MainActor
final class SpendDashboardSnapshotTests: XCTestCase {
    
    let record = true
    
    func test_dashboard_snapshot_initial() {
        let view = SpendDashboardView()
            .modelContainer(.mock)
        
        verifySnapshots(
            view,
            record: record
        )
    }
}
