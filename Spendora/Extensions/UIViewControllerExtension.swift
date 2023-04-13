//
//  UIViewControllerExtension.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/23.
//

import Foundation
import UIKit

extension UIViewController {
    /// This function makes the current view controller as the root view controller of the window
    /// Parameters:
    func makeRootViewController() {
        let navigationController = UINavigationController(rootViewController: self)
        AppDelegate.shared().window?.rootViewController = navigationController
        AppDelegate.shared().window?.makeKeyAndVisible()
    }
}
