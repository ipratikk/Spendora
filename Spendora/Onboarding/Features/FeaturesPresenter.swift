//
//  FeaturesPresenter.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 16/04/23.
//

import Foundation
import RxSwift
import RxCocoa
import Utilities
import UIKit

public final class FeaturesPresenter: FeaturesPresentation {
    let output: Output

    let input: Input

    let subviews: Subviews
    public typealias Submodules = (feature: (Feature) -> UIView, ())

    private let disposeBag = DisposeBag()

    init(input: Input, router: FeaturesRouter, submodules: Submodules) {
        self.input = input
        self.output = type(of: self).output(with: input)
        self.subviews = type(of: self).subviews(with: submodules, output: output)
        process(input, with: router)
    }
}

private extension FeaturesPresenter {
    private static func output(with input: Input) -> Output {
        let features = Feature.all
        let featureDriver = Driver.just(features)

        let currentPage = input.currentPage.asDriver(onErrorJustReturn: 0)
            .distinctUntilChanged()
        return (
            features: featureDriver,
            currentPage: currentPage
        )
    }

    private static func subviews(with submodules: Submodules, output: Output) -> Subviews {
        let featureViews = output.features
            .map { featureList in
                return featureList.map { (feature) -> UIView in
                    submodules.feature(feature)
                }
            }
        return (
            features: featureViews,
            ()
        )
    }

    private func process(_ input: Input, with router: FeaturesRouter) {
        input.didTapContinue
            .drive(onNext: {
                let defaults = UserDefaults.standard
                defaults.setValue(true, forKey: Constants.UserdefaultKeys.isOnboarded.rawValue)
                router.routeToAuthentication()
            })
            .disposed(by: disposeBag)
    }
}
