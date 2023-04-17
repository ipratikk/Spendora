//
//  OnboardingRouter.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 14/04/23.
//

import Foundation
import UIKit

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
        view.present(tncPrivacy, animated: true)
    }

    func routeToFeatures(){
        let features = submodules.features
        view.navigationController?.pushViewController(features, animated: true)
        view.navigationController?.isNavigationBarHidden = true
    }

    func showAlert() {
        let alert = UIAlertController(title: .empty, message: Module.Strings.Alert.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .default))
        view.present(alert, animated: true)
    }
}
