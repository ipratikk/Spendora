//
//  AuthButton.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 21/04/23.
//

import Foundation
import UIKit

public struct AuthButtonModel {
    let image: UIImage?
    let background: UIColor
}

public enum AuthButton {
    case google
    case apple
    case phone

    var image: UIImage? {
        switch self {
            case .google:
                return UIImage(named: "googleLogo")
            case .apple:
                return UIImage(named: "appleLogo")?.withTintColor(.white)
            case .phone:
                return UIImage()
        }
    }

    var background: UIColor {
        switch self {
            case .google:
                return .white
            case .apple:
                return .black
            case .phone:
                return .clear
        }
    }

    var model: AuthButtonModel {
        return AuthButtonModel(image: image, background: background)
    }
}
