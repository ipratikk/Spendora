//
//  CountryPickerRouter.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 23/04/23.
//

import Foundation
import UIKit

public final class CountryPickerRouter {
    public typealias Submodules = (
        noData: UIView,
        ()
    )

    private unowned let view: UIViewController
    private let submodules: Submodules

    init(view: UIViewController, submodules: Submodules) {
        self.view = view
        self.submodules = submodules
    }
}

extension CountryPickerRouter {
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error Occured", message: "Error occured while fetching country data", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: {_ in
            self.view.dismiss(animated: true)
        })
        alert.addAction(dismissAction)
        view.present(alert, animated: true)
    }

}
