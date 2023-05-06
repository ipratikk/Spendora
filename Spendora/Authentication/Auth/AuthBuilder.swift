//
//  AuthBuilder.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import Utilities
import UIKit

public final class AuthBuilder {
    public static func build(
        submodules: AuthRouter.Submodules,
        useCases: AuthPresenter.UseCases) -> UIViewController {
        let view = AuthViewController.initFromNib()
        let router = AuthRouter(view: view, submodules: submodules)
        view.presenterProducer = {
            AuthPresenter(
                input: $0,
                router: router,
                useCases: useCases
            )
        }
        return view
    }
}
