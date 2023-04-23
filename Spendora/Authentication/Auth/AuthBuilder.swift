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
    public static func build() -> UIViewController {
        let view = AuthViewController.initFromNib()
        let router = AuthRouter(view: view)
        view.presenterProducer = {
            AuthPresenter(input: $0, router: router)
        }
        return view
    }
}
