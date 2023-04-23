//
//  CountryPickerBuilder.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 21/04/23.
//

import Foundation
import UIKit

public final class CountryPickerBuilder {
    public static func build(submodules: (forRouter: CountryPickerRouter.Submodules, forPresenter: CountryPickerPresenter.Submodules),
                             useCases: CountryPickerPresenter.UseCases
    ) -> UIViewController {
        let view = CountryPickerViewController.initFromNib()
        let router = CountryPickerRouter(view: view, submodules: submodules.forRouter)
        view.presenterProducer = {
            CountryPickerPresenter(
                input: $0,
                router: router,
                dependencies: (
                    useCases: useCases,
                    submodules: submodules.forPresenter
                )
            )
        }
        return view
    }
}
