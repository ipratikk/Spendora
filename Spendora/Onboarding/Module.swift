//
//  Module.swift
//  Spendora
//
//  Created by Pratik Goel on 11/04/23.
//

import Foundation
import Lottie
import UIKit

final class Module {
    static let bundle = Bundle(for: Module.self)
    enum Strings {
        static let title = NSLocalizedString("onboarding.title.text", bundle: bundle, comment: "")
        static let tncText = NSLocalizedString("onboarding.tnc.text", bundle: bundle, comment: "")
        static let tncTnc = NSLocalizedString("onboarding.tnc.tnc", bundle: bundle, comment: "")
        static let tncPrivacy = NSLocalizedString("onboarding.tnc.privacy", bundle: bundle, comment: "")
        static let getStarted = NSLocalizedString("onboarding.start.button", bundle: bundle, comment: "")

        static let termsAndConditions = NSLocalizedString("onboarding.tnc.termsAndConditions", comment: "")
        static let termsAndConditionsLastUpdated = NSLocalizedString("onboarding.tnc.terms.lastUpdated", comment: "")
        static let termsAndConditionsEmail = NSLocalizedString("onboarding.tnc.terms.email", comment: "")

        static let privacyPolicy = NSLocalizedString("onboarding.tnc.privacyPolicy", comment: "")

        enum Alert {
            static let message = NSLocalizedString("onboarding.alert.message", comment: "")
        }

        enum Features {
            static let listExpenseTitle = NSLocalizedString("features.list.expenses.title", comment: "")
            static let listExpenseBody = NSLocalizedString("features.list.expenses.body", comment: "")
            static let splitExpenseTitle = NSLocalizedString("features.split.expenses.title", comment: "")
            static let splitExpenseBody = NSLocalizedString("features.split.expenses.body", comment: "")
            static let analyzeExpenseTitle = NSLocalizedString("features.analyze.expenses.title", comment: "")
            static let analyzeExpenseBody = NSLocalizedString("features.analyze.expenses.body", comment: "")
        }
    }

    enum Animations {
        static let finance = LottieAnimation.named("finance")
        static let listExpense = LottieAnimation.named("listExpense")
        static let splitExpense = LottieAnimation.named("splitExpense")
        static let analyzeExpense = LottieAnimation.named("analyzeExpense")
    }

    enum Images {
        static let unchecked = UIImage(systemName: "checkmark.circle")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        static let checked = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        static let rightArrow = UIImage(systemName: "chevron.right")
    }
}
