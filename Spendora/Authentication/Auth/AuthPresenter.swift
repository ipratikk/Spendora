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

public final class AuthPresenter: AuthPresentation {
    let output: Output

    let input: Input

    public typealias Submodules = (feature: () -> UIView, ())

    private let disposeBag = DisposeBag()

    init(input: Input, router: AuthRouter) {
        self.input = input
        self.output = type(of: self).output(with: input)
        process(input, with: router)
    }
}

private extension AuthPresenter {
    private static func output(with input: Input) -> Output {
        let authPhoneEnabled = input.phoneNumberText
            .map { $0.count == 10 }
        return (
            countryCode: Driver.just("+91"),
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
