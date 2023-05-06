//
//  Module.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 06/05/23.
//

import Foundation
import UIKit

final class Module {
    static let bundle = Bundle(for: Module.self)
    enum Auth {
        enum Strings {
            static let title = localized("auth.title.text")
            static let subtitle = localized("auth.subtitle.text")
            static let placeholder = localized("auth.number.placeholder.text")
            static let numButton = localized("auth.number.button.text")
            static let otherTitle = localized("auth.other.title.text")
            static let signup = localized("auth.signup.text")
            static let signin = localized("auth.signin.text")
            static let countryCode = localized("auth.countrycode.text")
        }
        enum Images {
            static let signupImage = UIImage(named: "signupVector")
            static let signinImage = UIImage(named: "signinVector")
        }
    }

    static func localized(_ key: String) -> String {
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
