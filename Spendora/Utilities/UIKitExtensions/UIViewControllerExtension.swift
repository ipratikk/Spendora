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
    func show(_ viewController: UIViewController, type: PushType, animated: Bool, withNavigationBar: Bool = true) {
        switch type {
            case .push:
                if let navigationController = navigationController {
                    navigationController.pushViewController(viewController, animated: animated)
                    navigationController.isNavigationBarHidden = !withNavigationBar
                }
            case .present:
                if withNavigationBar {
                    let navigationController = UINavigationController(rootViewController: viewController)
                    present(navigationController, animated: animated)
                } else {
                    present(viewController, animated: animated, completion: nil)
                }
        }
    }

    func makeRootViewController() {
        let navigationController = UINavigationController(rootViewController: self)
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = navigationController
        appDelegate?.window??.makeKeyAndVisible()
    }
}

public extension UIViewController {
    func addKeyboardNotification(with scrollView: UIScrollView) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            self.keyboardWillShow(notification, scrollView: scrollView)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            self.keyboardWillHide(notification, scrollView: scrollView)
        }
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

    private func keyboardWillShow(_ notification: Notification, scrollView: UIScrollView) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25

        UIView.animate(withDuration: duration) {
            scrollView.contentInset.bottom = keyboardHeight
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.verticalScrollIndicatorInsets = contentInsets
        }
    }

    private func keyboardWillHide(_ notification: Notification, scrollView: UIScrollView) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25

        UIView.animate(withDuration: duration) {
            scrollView.contentInset.bottom = 0
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            scrollView.verticalScrollIndicatorInsets = contentInsets
        }
    }
}

public extension UIViewController {
    func getAttributedString(from string: String, with placeholder: String, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let range = (attributedString.string as NSString).range(of: placeholder)
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
}
