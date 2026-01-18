//
//  Color+Extension.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 30/08/25.
//

import SwiftUI

public extension Color {
    // MARK: - Backgrounds
    static var primaryBackground: Color { Color("primaryBackground") }
    static var secondaryBackground: Color { Color("secondaryBackground") }
    static var tertiaryBackground: Color { Color("tertiaryBackground") }
    
    
    // MARK: - Buttons
    static var buttonBackground: Color { Color("buttonBackground") }
    
    // MARK: - UI Elements
    
    /// Separator/divider line color (rgba(84, 84, 88, 0.6))
    static var separator: Color {
        Color(red: 84/255, green: 84/255, blue: 88/255).opacity(0.6)
    }
}

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
