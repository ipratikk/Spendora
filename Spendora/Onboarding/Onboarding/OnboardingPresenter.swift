//
//  OnboardingPresenter.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 14/04/23.
//

import Foundation
import RxSwift
import RxCocoa
import Utilities

final class OnboardingPresenter: OnboardingPresentation {
    private let disposeBag = DisposeBag()
    init(input: Input, router: OnboardingRouter) {
        process(input, with: router)
    }
}

private extension OnboardingPresenter {
    func process(_ input: Input, with router: OnboardingRouter) {
        input.tapTncLabel.drive(onNext: { link in
            switch link {
                case "terms":
                    router.routeToTnc(type: .tnc)
                case "privacy":
                    router.routeToTnc(type: .privacy)
                default:
                    ()
            }
        }).disposed(by: disposeBag)

        input.clickStartBtn
            .withLatestFrom(input.isCheckboxSelected)
            .map { $0 }
            .drive(onNext: { isValid in
                if isValid {
                    router.routeToFeatures()
                } else {
                    router.showAlert()
                }
            })
            .disposed(by: disposeBag)
    }
}
