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

    func routeToFeatures(from view: UIViewController, type: PushType) {
        let featuresVC = AppAssembler.featuresModule()
        view.show(featuresVC, type: .push, animated: true)
    }
}
