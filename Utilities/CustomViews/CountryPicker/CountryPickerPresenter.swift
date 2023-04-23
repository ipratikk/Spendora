//
//  CountryPickerPresenter.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 21/04/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public final class CountryPickerPresenter: CountryPickerPresentation {
    public typealias UseCases = (
        output: (
            countries: Driver<[Country]>,
            ()
        ),
        input: (
            selectedCountry: (_ country: Country) -> Void,
            ()
        )
    )

    let output: Output
    let input: Input

    let subviews: Subviews
    public typealias Submodules = (noData: (_ image: UIImage?, _ title: String) -> UIView, ())

    typealias Dependencies = (useCases: UseCases, submodules: Submodules)

    private let disposeBag = DisposeBag()

    init(input: Input, router: CountryPickerRouter, dependencies: Dependencies) {
        self.input = input
        self.output = type(of: self).output(with: input, usecases: dependencies.useCases)
        self.subviews = type(of: self).subviews(with: dependencies.submodules)
        process(input, with: router, useCases: dependencies.useCases)
    }
}

private extension CountryPickerPresenter {
    private static func output(with input: Input, usecases: UseCases) -> Output {
        return (
            usecases.output.countries,
            ()
        )
    }

    private static func subviews(with submodules: Submodules) -> Subviews {
        let noDataView = submodules.noData(
            UIImage(systemName: "globe"),
            "No Results"
        )
        return (
            noData: noDataView,
            ()
        )
    }

    private func process(_ input: Input, with router: CountryPickerRouter, useCases: UseCases) {
        input.selectedCountry
            .drive(onNext: {
                useCases.input.selectedCountry($0!)
            })
            .disposed(by: disposeBag)
    }
}
