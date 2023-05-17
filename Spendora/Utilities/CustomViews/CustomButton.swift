//
//  CustomButton.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 20/04/23.
//

import Foundation
import UIKit

public final class CustomButton: UIButton {
    public func setup(with button: AuthButton) {
        let logoView = AuthButtonView.loadFromNib()
        logoView.frame = self.bounds
        logoView.setup(image: button.image, backgroundColor: button.background)
        self.addSubview(logoView)

            // Set the corner radius of the button and the subview
        self.layer.cornerRadius = frame.height / 2
        logoView.layer.cornerRadius = frame.height / 2
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        addDefaultShadow()
    }
}
