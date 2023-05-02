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

public extension UIViewController {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25

        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = -keyboardHeight // adjust the view's Y position to move it up by the keyboard height
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25

        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = 0 // reset the view's Y position
        }
    }
}
