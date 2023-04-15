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

final class Presenter: Presentation {
    private let disposeBag = DisposeBag()
    init(input: Input, router: Router) {
        process(input, with: router)
    }
}

private extension Presenter {
    func process(_ input: Input, with router: Router) {
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
            .drive(onNext: { value in
                if value {
                    let defaults = UserDefaults.standard
                    defaults.setValue(true, forKey: Constants.UserdefaultKeys.isOnboarded.rawValue)
                    router.routeToTnc(type: .tnc)
                } else {
                    router.showAlert()
                }
            })
            .disposed(by: disposeBag)
    }
}
