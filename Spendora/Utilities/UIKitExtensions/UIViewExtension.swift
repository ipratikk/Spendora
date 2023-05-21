//
//  UIViewExt.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/23.
//

import Foundation
import UIKit

public protocol NibLoadable: AnyObject {
    static var nibName: String { get }
}

public extension NibLoadable {
    static var nibName: String {
        return String(describing: Self.self)
    }
}

public extension NibLoadable {
    static func loadFromNib() -> Self {
        return loadFromNib(from: Bundle.init(for: self))
    }

    static func loadFromNib(from bundle: Bundle) -> Self {
        return bundle.loadNibNamed(self.nibName, owner: nil, options: nil)?.first as! Self
    }

    func loadNib() {
        loadNib(from: Bundle.init(for: type(of: self)))
    }

    func loadNib(from bundle: Bundle) {
        bundle.loadNibNamed(Self.nibName, owner: self, options: nil)
    }
}

public extension UITableView {
    func registerCellNib<T: UITableViewCell>(_ cellClass: T.Type) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: Bundle(for: cellClass))
        register(nib, forCellReuseIdentifier: String(describing: cellClass))
    }

    func registerHeaderNib<T: UITableViewHeaderFooterView>(_ cellClass: T.Type) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: Bundle(for: cellClass))
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: cellClass))
    }
}

public extension UIView {
    @objc func addDefaultShadow(color: UIColor = .defaultShadow, width: CGFloat = 0, height: CGFloat = 0, opacity: Float = 0.1, radius: CGFloat = 10) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }

    @objc func removeBottomShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: -self.layer.shadowRadius)
    }

    @objc func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
