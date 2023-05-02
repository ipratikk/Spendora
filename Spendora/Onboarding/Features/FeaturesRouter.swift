//
//  FeaturesRouter.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 16/04/23.
//

import Foundation
import UIKit
import Authentication
import Utilities

public final class FeaturesRouter {
    public typealias Submodules = (
        singup: UIViewController,
        signin: UIViewController
    )

    private unowned let view: UIViewController
    private let submodules: Submodules

    init(view: UIViewController, submodules: Submodules) {
        self.view = view
        self.submodules = submodules
    }
}

extension FeaturesRouter {
    func routeToAuthentication() {
        let authVC = submodules.singup
        view.navigationController?.pushViewController(authVC, animated: true)
//        view.present(authVC, animated: true)
    }
}
