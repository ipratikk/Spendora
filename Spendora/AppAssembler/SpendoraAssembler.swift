//
//  SpendoraAssembler.swift
//  Spendora
//
//  Created by Pratik Goel on 14/04/23.
//

import Foundation
import UIKit
import Onboarding

public final class AppAssembler {
    static func onboardingModule() -> UIViewController {
        return OnboardingBuilder.build(
            submodules: (
                tncPrivacy: TncPrivacyBuilder.build,
                features: featuresModule()
            )
        )
    }

    static func featuresModule() -> UIViewController {
        return FeaturesBuilder.build(
            submodules: (
                forRouter: (tncPrivacy: TncPrivacyBuilder.build, ()),
                forPresenter: (feature: FeatureCardBuilder.build, ())
            ))
    }

    static func tncPrivacyModule() -> UIViewController {
        return TncPrivacyBuilder.build(type: .tnc)
    }
}
