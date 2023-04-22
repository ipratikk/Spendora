//
//  SignupRouter.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import UIKit
import Utilities

public final class SignupRouter {
//    public typealias Submodules = (tncPrivacy: (TncType) -> UIViewController, ())

    private unowned let view: UIViewController

//    private let submodules: Submodules
//
//    init(view: UIViewController, submodules: Submodules) {
//        self.view = view
//        self.submodules = submodules
//    }

    init(view: UIViewController){
        self.view = view
    }
}

extension SignupRouter {
    func routeToAuthentication() {
        let authVC = SignupViewController.initFromNib()
            //        view.navigationController?.pushViewController(authVC, animated: true)
        view.present(authVC, animated: true)
    }
}
