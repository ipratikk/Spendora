//
//  OTPBuilder.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 10/05/23.
//

import Foundation
import Utilities
import UIKit

public final class OTPBuilder {
    public static func build(
        submodules: OTPRouter.Submodules,
        useCases: OTPPresenter.UseCases
    ) -> UIViewController {
            let view = OTPViewController.initFromNib()
            let router = OTPRouter(view: view, submodules: submodules)
            view.presenterProducer = {
                OTPPresenter(
                    input: $0,
                    router: router,
                    useCases: useCases
                )
            }
            return view
        }
}
