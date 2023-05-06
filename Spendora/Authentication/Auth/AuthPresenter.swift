//
//  AuthPresenter.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Utilities
import CoreLocation


public enum AuthType: String {
    case signup = "Sign Up"
    case signin = "Sign In"
}


public final class AuthPresenter: AuthPresentation {
    let output: Output

    let input: Input

    public typealias UseCases = (
        output: (
            selectedCountry: Driver<Country?>,
            authType: Driver<AuthType>
        ),
        input: (
            ()
        )
    )

    private let disposeBag = DisposeBag()

    init(input: Input, router: AuthRouter, useCases: UseCases) {
        self.input = input
        self.output = type(of: self).output(with: input, useCases: useCases)
        process(input, with: router, useCases: useCases)
    }
}

private extension AuthPresenter {

    static let staticDisposeBag = DisposeBag()

    private static func output(with input: Input, useCases: UseCases) -> Output {
        let authPhoneEnabled = Driver.combineLatest(input.phoneNumberText, useCases.output.selectedCountry)
            .map { phoneNumber, country in
                guard country != nil else { return false }
                return phoneNumber.count == 10
            }
            .startWith(false)
        return (
            countryCode: useCases.output.selectedCountry,
            isAuthNumberEnabled: authPhoneEnabled,
            authType: useCases.output.authType
        )
    }

    private func process(_ input: Input, with router: AuthRouter, useCases: UseCases) {
        input.authNumberTapped
            .withLatestFrom(input.phoneNumberText) { _, phoneNumber in
                return phoneNumber
            }
            .withLatestFrom(useCases.output.selectedCountry) { phoneNumber, country in
                return (phoneNumber, country)
            }
            .drive(onNext: { (phoneNumber, country) in
                guard let country = country else { return }
                let phoneNumberWithCode = country.dial_code + phoneNumber
                router.routeToOTP()
//                AuthManager.shared.startAuth(phoneNumber: phoneNumberWithCode, completion: {_ in
//                    
//                })
            })
            .disposed(by: disposeBag)

        input.countryCodeButtonTapped
            .drive(onNext: {
                router.routeToCountryPicker()
            })
            .disposed(by: disposeBag)
    }
}
