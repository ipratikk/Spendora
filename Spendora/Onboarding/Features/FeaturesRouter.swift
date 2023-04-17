//
//  FeaturesRouter.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 16/04/23.
//

import Foundation
import UIKit

public final class FeaturesRouter {
    public typealias Submodules = (tncPrivacy: (TncType) -> UIViewController, ())

    private unowned let view: UIViewController
    private let submodules: Submodules

    init(view: UIViewController, submodules: Submodules) {
        self.view = view
        self.submodules = submodules
    }
}

extension FeaturesRouter {
    func routeToTnc(type: TncType) {
        let tncPrivacy = submodules.tncPrivacy(type)
        view.present(tncPrivacy, animated: true)
    }
}
