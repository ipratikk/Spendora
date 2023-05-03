//
//  OnboardingRouter.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 14/04/23.
//

import Foundation
import UIKit
import Utilities

public final class OnboardingRouter {
    public typealias Submodules = (
        tncPrivacy: (TncType) -> UIViewController,
        features: UIViewController
    )

    private unowned let view: UIViewController
    private let submodules: Submodules

    init(view: UIViewController, submodules: Submodules) {
        self.view = view
        self.submodules = submodules
    }
}

extension OnboardingRouter {
    func routeToTnc(type: TncType) {
        let tncPrivacy = submodules.tncPrivacy(type)
        view.show(tncPrivacy, type: .present, animated: true, withNavigationBar: false)
    }

    func routeToFeatures(){
        let features = submodules.features
        features.makeRootViewController()
//        view.show(features, type: .push, animated: true, withNavigationBar: false)
    }

    func showAlert() {
        let alert = UIAlertController(title: .empty, message: Module.Strings.Alert.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .default))
        view.show(alert, type: .present, animated: true, withNavigationBar: false)
    }
}
