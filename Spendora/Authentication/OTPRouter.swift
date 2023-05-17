//
//  OTPRouter.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 10/05/23.
//

import Foundation
import UIKit
import Utilities

public final class OTPRouter {
    public typealias Submodules = (
        setupAccount: () -> UIViewController,
        homeView: () -> UIViewController
    )

    private unowned let view: UIViewController
    private let submodules: Submodules

    init(view: UIViewController, submodules: Submodules) {
        self.view = view
        self.submodules = submodules
    }
}

extension OTPRouter {
    func routeToHomeScreen() {
        let authVC = submodules.homeView()
        authVC.makeRootViewController()
    }

    func routeToSetupAccount() {
        let authVC = submodules.setupAccount()
        authVC.view.backgroundColor = .gray
        view.show(authVC, type: .push, animated: true)
    }

    func showAlert(_ error: Error) {
        let errorMessage = String(format: Module.OTP.Alert.message, error.localizedDescription)
        let alert = UIAlertController(title: .empty, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .default))
        view.show(alert, type: .present, animated: true, withNavigationBar: false)
    }
}
