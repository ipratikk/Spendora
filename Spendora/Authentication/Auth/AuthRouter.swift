//
//  AuthRouter.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import UIKit
import Utilities

public final class AuthRouter {
    public typealias Submodules = (
        countryPicker: UIViewController,
        otpModule: (_ phoneNumber: String) -> UIViewController
    )

    private unowned let view: UIViewController

    private let submodules: Submodules

    init(view: UIViewController, submodules: Submodules) {
        self.view = view
        self.submodules = submodules
    }
}

extension AuthRouter {
    func routeToCountryPicker() {
        let countryPickerVC = submodules.countryPicker
        view.show(countryPickerVC, type: .present, animated: true)
    }

    func routeToOTP(with phoneNumber: String) {
        let otpVC = submodules.otpModule(phoneNumber)
        view.show(otpVC, type: .push, animated: true)
    }

    func showAlert(_ error: Error) {
        let errorMessage = String(format: Module.OTP.Alert.message, error.localizedDescription)
        let alert = UIAlertController(title: .empty, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .default))
        view.show(alert, type: .present, animated: true, withNavigationBar: false)
    }
}
