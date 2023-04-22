//
//  SignupPresenter.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public final class SignupPresenter: SignupPresentation {
    let output: Output

    let input: Input

    public typealias Submodules = (feature: () -> UIView, ())

    private let disposeBag = DisposeBag()

    init(input: Input, router: SignupRouter) {
        self.input = input
        self.output = type(of: self).output(with: input)
        process(input, with: router)
    }
}

private extension SignupPresenter {
    private static func output(with input: Input) -> Output {
        let signupPhoneEnabled = input.phoneNumberText
            .map { $0.count == 10 }
        return (
            countryCode: Driver.just("+91"),
            isSignupNumberEnabled: signupPhoneEnabled
        )
    }

    private func process(_ input: Input, with router: SignupRouter) {
        input.signupNumberTapped
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
    }
}
