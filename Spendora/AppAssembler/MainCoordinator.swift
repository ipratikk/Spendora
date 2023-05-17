//
//  MainCoordinator.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import UIKit
import Utilities

public final class MainCoordinator {
    let defaults = UserDefaults.standard

    func startOnboardingFlow() {
//        defaults.set(false, forKey: Constants.UserdefaultKeys.isOnboarded.rawValue)
        let isOnboarded = defaults.bool(forKey: Constants.UserdefaultKeys.isOnboarded.rawValue)
        guard isOnboarded else {
            let onboardingVC = AppAssembler.onboardingModule()
            onboardingVC.makeRootViewController()
            return
        }
        let authVC = AppAssembler.authModule()
        authVC.makeRootViewController()
    }

    func routeToFeatures(from view: UIViewController, type: PushType) {
        let featuresVC = AppAssembler.featuresModule()
        view.show(featuresVC, type: .push, animated: true)
    }

    func routeToHome(with user: FirebaseUser) {
        guard user.isProfileComplete else {
            routeToAccountSetup(with: user)
            return
        }
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        vc.title = "Home"
        vc.makeRootViewController()
    }

    func routeToAccountSetup(with user: FirebaseUser) {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .green
//        vc.title = "Account Setup"
        let vc = AppAssembler.accountModule()
        vc.makeRootViewController()
    }
}
