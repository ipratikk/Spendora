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
    public typealias Submodules = (countryPicker: UIViewController, ())

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

    func routeToOTP() {
        let otpVC = OTPViewController.initFromNib()
        view.show(otpVC, type: .push, animated: true)
    }
}
