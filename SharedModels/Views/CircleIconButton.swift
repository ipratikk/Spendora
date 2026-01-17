//
//  CircleIconButton.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 15/09/25.
//

import SwiftUI

public struct CircleIconButton: View {
    let systemName: String
    
    public init(systemName: String) {
        self.systemName = systemName
    }
    
    public var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 36, height: 36)
            .background(Circle().fill(Color.blue))
            .shadow(radius: 2)
    }
}
