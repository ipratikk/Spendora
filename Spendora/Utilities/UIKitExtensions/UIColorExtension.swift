//
//  UIColorExtension.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 18/04/23.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

public extension UIColor {

    static func get(light: String, dark: String) -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        }
    }

    static let primaryBackground: UIColor = get(light: "#FBF8F2", dark: "#101413")
    static let primaryButton: UIColor = get(light: "#000000", dark: "#FBF8F2")
    static let primaryButtonTitle: UIColor = get(light: "#FFFFFF", dark: "#000000")
    static let defaultShadow: UIColor = get(light: "#808080", dark: "#555555")
    static let pageControlSelected: UIColor = get(light: "#000000", dark: "#ffffff")
    static let pageControlTint: UIColor = get(light: "#9A9A9A", dark: "#262626")
}
