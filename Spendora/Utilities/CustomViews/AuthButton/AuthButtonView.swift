//
//  AuthButtonView.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 19/04/23.
//

import UIKit

private let authButtonView = "AuthButtonView"
class AuthButtonView: UIView, NibLoadable {
    private(set) static var nibName: String = authButtonView

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(image: UIImage?, backgroundColor: UIColor) {
        imageView.image = image
        self.backgroundColor = backgroundColor
    }
}
