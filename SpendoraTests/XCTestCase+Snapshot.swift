//
//  XCTestCase+Snapshot.swift
//  SpendoraTests
//
//  Created by Pratik Goel on 13/04/26.
//

import Foundation
import XCTest
import SnapshotTesting
import SwiftUI

extension XCTestCase {
    func verifySnapshots<V: View>(
        _ view: V,
        record: Bool = true,
        file: StaticString = #file,
        testName: String = #function
    ) {
        let baseName = testName
            .replacingOccurrences(of: "test_", with: "")
            .split(separator: "_")
            .map { $0.capitalized }
            .joined()
        
        // Light
        assertSnapshot(
            of: view.environment(\.colorScheme, .light),
            as: .image(layout: .device(config: .iPhone13)),
            named: "Light",
            record: record,
            file: file,
            testName: baseName
        )
        
        // Dark
        assertSnapshot(
            of: view.environment(\.colorScheme, .dark),
            as: .image(layout: .device(config: .iPhone13)),
            named: "Dark",
            record: record,
            file: file,
            testName: baseName
        )
    }
}
