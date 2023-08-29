//
//  AccountBuilder.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 24/05/23.
//

import Foundation
import Utilities
import UIKit

public final class AccountBuilder {
    public static func build(
        submodules: AccountRouter.Submodules,
        useCases: AccountPresenter.UseCases) -> UIViewController {
            let view = AccountViewController.initFromNib()
            let router = AccountRouter(view: view, submodules: submodules)
            view.presenterProducer = {
                AccountPresenter(
                    input: $0,
                    router: router,
                    useCases: useCases
                )
            }
            return view
        }
}
