//
//  SpendoraAssembler.swift
//  Spendora
//
//  Created by Pratik Goel on 14/04/23.
//

import Foundation
import UIKit
import Onboarding
import Authentication
import Utilities
import RxSwift
import RxCocoa

public final class AppAssembler {

    private static let countryPickerInteractor = CountryPickerInteractor()

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
                forRouter: (
                    singup: signupModule(),
                    signin: signupModule()
                ),
                forPresenter: (
                    feature: FeatureCardBuilder.build,
                    ()
                )
            ))
    }

    static func countryPickerModule() -> UIViewController {
        return CountryPickerBuilder.build(
            submodules:
                (
                    forRouter: (
                        noData: UIView(),
                        ()
                    ),
                    forPresenter: (
                        noData: noDataModule,
                        ()
                    )
                ),
            useCases: (
                output: (
                    countries: countryPickerInteractor.countriesList,
                    ()
                ),
                input: (
                    selectedCountry: countryPickerInteractor.setSelectedCountry,
                    ()
                )
            )
        )
    }

    static func tncPrivacyModule() -> UIViewController {
        return TncPrivacyBuilder.build(type: .tnc)
    }

    static func noDataModule(image: UIImage?, title: String) -> UIView {
        return NoDataViewBuilder.build(image: image, title: title)
    }

    static func signupModule() -> UIViewController {
        return AuthBuilder.build(
            submodules: (
                countryPicker: countryPickerModule(),
                ()
            ),
            useCases: (
                output: (
                    selectedCountry: countryPickerInteractor.selectedCountry,
                    ()
                ),
                input: (
                    ()
                )
            )
        )
    }
}
