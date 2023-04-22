//
//  SignupBuilder.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import Utilities
import UIKit

public class SignupBuilder {
    public static func build() -> UIViewController {
        let view = SignupViewController.initFromNib()
        let router = SignupRouter(view: view)
        view.presenterProducer = {
            SignupPresenter(input: $0, router: router)
        }
        return view
    }
}
