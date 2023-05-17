//
//  OTPPresenter.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 10/05/23.
//

import Foundation
import RxSwift
import RxCocoa
import Utilities
import UIKit
import SVProgressHUD

public final class OTPPresenter: OTPPresentation {
    let output: Output

    let input: Input

    public typealias UseCases = (
        output: (
            phoneNumber: Driver<String>,
            ()
        ),
        input: (
            ()
        )
    )

    private let disposeBag = DisposeBag()

    init(input: Input, router: OTPRouter, useCases: UseCases) {
        self.input = input
        self.output = type(of: self).output(with: input, useCases: useCases)
        process(input, with: router)
    }
}

private extension OTPPresenter {
    private static func output(with input: Input, useCases: UseCases) -> Output {
        let isVerifyEnabled = input.otpCode
            .map { code in
                guard code.joined().count == 6 else {
                    return false
                }
                return true
            }
            .startWith(false)
        return (
            phoneNumber: useCases.output.phoneNumber,
            isVerfifyOTPEnabled: isVerifyEnabled
        )
    }

    private func process(_ input: Input, with router: OTPRouter) {
        input.didTapContinue
            .withLatestFrom(input.otpCode) { _, code in
                return code.joined()
            }
            .drive(onNext: { otp in
                print("OTP: \(otp)")
                SVProgressHUD.show(withStatus: Module.OTP.Strings.otpVerifying)
                AuthManager.shared.verify(smsCode: otp) { result in
                    switch result {
                        case .success:
                            SVProgressHUD.showSuccess(withStatus: Module.OTP.Strings.otpVerified)
                            SVProgressHUD.dismiss(withDelay: 1.0) {
                                router.routeToSetupAccount()
                            }
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            router.showAlert(error)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
