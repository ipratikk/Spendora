//
//  AuthBuilder.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import Utilities
import UIKit

public class AuthBuilder {
    public static func build(submodules: AuthRouter.Submodules) -> UIViewController {
        let view = AuthViewController.initFromNib()
        let router = AuthRouter(view: view, submodules: submodules)
        view.presenterProducer = {
            AuthPresenter(input: $0, router: router)
        }
        return view
    }
}
