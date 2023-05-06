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
        authentication: (_ authType: AuthType) -> UIViewController,
        ()
    )

    private unowned let view: UIViewController
    private let submodules: Submodules

    init(view: UIViewController, submodules: Submodules) {
        self.view = view
        self.submodules = submodules
    }
}

extension FeaturesRouter {
    func routeToAuthentication(_ authType: AuthType) {
        let authVC = submodules.authentication(authType)
        view.show(authVC, type: .push, animated: true)
    }
}
