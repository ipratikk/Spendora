//
//  Text+Extension.swift
//  SharedModels
//
//  Created by Pratik Goel on 01/09/25.
//

import SwiftUI

public extension Text {
    func dueDateStyle() -> some View {
        self
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(16)
            .font(.caption)
    }
}

