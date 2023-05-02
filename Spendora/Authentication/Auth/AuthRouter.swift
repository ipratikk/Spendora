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
        let navController = UINavigationController(rootViewController: countryPickerVC)
        if let sheets = countryPickerVC.sheetPresentationController {
            sheets.detents = [.medium()]
        }
        view.present(navController, animated: true)
    }

    func routeToOTP() {
        let otpVC = OTPViewController.initFromNib()
        view.navigationController?.pushViewController(otpVC, animated: true)
//        view.present(otpVC, animated: true)
    }
}
