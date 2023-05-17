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
            static let countryCode = localized("auth.countrycode.text")
        }
        enum Images {
            static let authImage = UIImage(named: "authVector")
        }
        enum Alert {
            static let message = NSLocalizedString("auth.error.alert.text", comment: "")
        }
    }

    enum OTP {
        enum Strings {
            static let title = localized("otp.title.text")
            static let subtitle = localized("otp.subtitle.text")
            static let resendTitle = localized("otp.resend.title")
            static let resendPlaceholder = localized("otp.resend.placeholder")
            static let resendTimeout = localized("otp.resend.timer.text")
            static let resendTimeoutPlaceholder = localized("otp.resend.timer.placeholder")
            static let verify = localized("otp.verify.text")
            static let otpVerifying = localized("otp.activity.verifying")
            static let otpVerified = localized("otp.activity.verified")
        }
        enum Images {
            static let otpImage = UIImage(named: "otpSecureEntry")
        }
        enum Alert {
            static let message = NSLocalizedString("otp.error.alert.text", comment: "")
        }
    }

    static func localized(_ key: String) -> String {
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
