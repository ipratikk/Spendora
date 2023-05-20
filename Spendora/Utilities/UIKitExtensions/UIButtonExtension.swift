//
//  UIButtonExtension.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 20/04/23.
//

import Foundation
import UIKit

public extension UIButton {
    func addDefaultShadow() {
        super.addDefaultShadow(height: 4.0, opacity: 0.1, radius: 3)
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            setBackgroundImage(colorImage, for: state)
        }
    }

    func setEnabledBackgroundColor(_ enabledColor: UIColor, disabledColor: UIColor) {
        if isEnabled {
            setBackgroundColor(enabledColor, for: .normal)
        } else {
            setBackgroundColor(disabledColor, for: .normal)
        }
    }
}
