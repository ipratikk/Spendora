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
import Account

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
                    authentication: authModule,
                    ()
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
                    selectedCountry: countryPickerInteractor.selectedCountry
                ),
                input: (
                    selectCountry: countryPickerInteractor.setSelectedCountry,
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

    static func authModule() -> UIViewController {
        return AuthBuilder.build(
            submodules: (
                countryPicker: countryPickerModule(),
                otpModule: otpModule
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

    static func otpModule(with phoneNumber: String) -> UIViewController {
        return OTPBuilder.build(
            submodules: (
                setupAccount: accountModule,
                homeView: emptyView
            ),
            useCases: (
                output: (
                    phoneNumber: Driver.just(phoneNumber),
                    ()
                ),
                input: (
                    ()
                )
            )
        )
    }

    static func accountModule() -> UIViewController {
        return AccountBuilder.build(
            submodules: (
                countryPicker: countryPickerModule(),
                ()
            ),
            useCases: (
                output: (
                    countries: countryPickerInteractor.countriesList,
                    selectedCountry: countryPickerInteractor.selectedCountry
                ),
                input: (
                    setSelectedCountry: countryPickerInteractor.selectCountry,
                    ()
                )
            )
        )
    }

    static func emptyView() -> UIViewController {
        return UIViewController()
    }
}
