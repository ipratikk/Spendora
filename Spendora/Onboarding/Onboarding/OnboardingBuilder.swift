//
//  Builder.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 14/04/23.
//

import Foundation
import UIKit
import Utilities

public class OnboardingBuilder {
    public static func build(submodules: OnboardingRouter.Submodules) -> UIViewController {

        let view = OnboardingViewController.initFromNib()
        let router = OnboardingRouter(view: view, submodules: submodules)
        view.presenterProducer = {
            OnboardingPresenter(input: $0, router: router)
        }
        return view
    }
}
