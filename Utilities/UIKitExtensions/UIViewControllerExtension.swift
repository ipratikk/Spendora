//
//  UIViewControllerExtension.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 14/04/23.
//

import Foundation
import UIKit

public enum PushType {
    case push
    case present
}


public extension UIViewController {
    class func instantiate<T: UIViewController>(from storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

    class func instantiate(from storyboard: UIStoryboard) -> Self {
        return instantiate(from: storyboard, identifier: String(describing: self))
    }

    class func instantiate() -> Self {
        let className = String(describing: self)
        return instantiate(from: UIStoryboard(name: className, bundle: Bundle(for: self)), identifier: className)
    }
}

    // MARK: Init from nib
public extension UIViewController {
    class func initFromNib(name: String) -> Self {
        return .init(nibName: name, bundle: Bundle(for: self))
    }

    class func initFromNib() -> Self {
        let className = String(describing: self)
        return initFromNib(name: className)
    }
}

public extension UIViewController {
    func show(_ viewController: UIViewController, type: PushType, animated: Bool) {
        switch type {
            case .push:
                if let navigationController = navigationController {
                    navigationController.pushViewController(viewController, animated: animated)
                }
            case .present:
                present(viewController, animated: animated, completion: nil)
        }
    }
}
