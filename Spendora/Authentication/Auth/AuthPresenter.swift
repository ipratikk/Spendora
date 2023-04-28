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

public final class AuthPresenter: AuthPresentation {
    let output: Output

    let input: Input

    public typealias UseCases = (
        output: (
            selectedCountry: Driver<Country?>,
            ()
        ),
        input: (
            ()
        )
    )

    private let disposeBag = DisposeBag()

    init(input: Input, router: AuthRouter, useCases: UseCases) {
        self.input = input
        self.output = type(of: self).output(with: input, useCases: useCases)
        process(input, with: router)
    }
}

private extension AuthPresenter {
    static let staticDisposeBag = DisposeBag()
    private static func output(with input: Input, useCases: UseCases) -> Output {
        let authPhoneEnabled = input.phoneNumberText
            .map { $0.count == 10 }
        useCases.output.selectedCountry
            .drive(onNext: { country in
                guard let country = country else { return }
                print(country)
            })
        return (
            countryCode: useCases.output.selectedCountry,
            isAuthNumberEnabled: authPhoneEnabled
        )
    }

    private func process(_ input: Input, with router: AuthRouter) {
        input.authNumberTapped
            .withLatestFrom(input.phoneNumberText)
            .map { $0 }
            .drive(onNext: { phoneNumber in
                guard phoneNumber.count == 10 else { return }
            })
            .disposed(by: disposeBag)

        input.phoneNumberText
            .drive(onNext:{ text in
                print(text)
            })
            .disposed(by: disposeBag)

        input.countryCodeButtonTapped
            .drive(onNext: {
                router.routeToCountryPicker()
            })
            .disposed(by: disposeBag)
    }
}
