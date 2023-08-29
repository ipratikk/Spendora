//
//  AccountRouter.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 24/05/23.
//

import Foundation
import UIKit
import Utilities

public final class AccountRouter {
    public typealias Submodules = (
        countryPicker: UIViewController,
        ()
    )

    private unowned let view: UIViewController

    private let submodules: Submodules

    init(view: UIViewController, submodules: Submodules) {
        self.view = view
        self.submodules = submodules
    }
}

extension AccountRouter {
    func routeToCountryPicker() {
        let countryPickerVC = submodules.countryPicker
        view.show(countryPickerVC, type: .present, animated: true)
    }

    func showAlert(_ error: Error) {
        let errorMessage = ""
        let alert = UIAlertController(title: .empty, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .default))
        view.show(alert, type: .present, animated: true, withNavigationBar: false)
    }
}
