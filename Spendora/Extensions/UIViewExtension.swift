//
//  UIViewExt.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 13/04/23.
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
