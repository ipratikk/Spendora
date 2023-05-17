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
import SVProgressHUD

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
            isAuthNumberEnabled: authPhoneEnabled
        )
    }

    private func process(_ input: Input, with router: AuthRouter, useCases: UseCases) {
        input.authNumberTapped
            .withLatestFrom(input.phoneNumberText) { _, phoneNumber in
                return phoneNumber
            }
            .withLatestFrom(useCases.output.selectedCountry) { phoneNumber, country in
                guard let country = country else { return "" }
                let phoneNumberWithCode = country.dial_code + phoneNumber
                return phoneNumberWithCode
            }
            .drive(onNext: { (phoneNumberWithCode: String) in
                SVProgressHUD.show()
                AuthManager.shared.startAuth(phoneNumber: phoneNumberWithCode, completion: { result in
                    SVProgressHUD.dismiss()
                    switch result {
                        case .success:
                            router.routeToOTP(with: phoneNumberWithCode)
                        case .failure(let error):
                            router.showAlert(error)
                    }
                })
            })
            .disposed(by: disposeBag)


        input.countryCodeButtonTapped
            .drive(onNext: {
                router.routeToCountryPicker()
            })
            .disposed(by: disposeBag)
    }
}
