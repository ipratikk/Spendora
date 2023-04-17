//
//  FeaturesBuilder.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 14/04/23.
//

import Foundation
import UIKit
import Utilities

public class FeaturesBuilder {
    public static func build(submodules: (forRouter: FeaturesRouter.Submodules, forPresenter: FeaturesPresenter.Submodules)) -> UIViewController {
        let view = FeaturesViewController.initFromNib()
        let router = FeaturesRouter(view: view, submodules: submodules.forRouter)
        view.presenterProducer = {
            FeaturesPresenter(input: $0, router: router, submodules: submodules.forPresenter)
        }
        return view
    }
}
