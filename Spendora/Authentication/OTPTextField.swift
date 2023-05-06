//
//  OTPTextField.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 07/05/23.
//

import Foundation
import UIKit

protocol OTPTextFieldDelegate: AnyObject {
    func textFieldDidDelete()
}

class OTPTextField: UITextField {
    weak var otpDelegate: OTPTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        otpDelegate?.textFieldDidDelete()
    }
}
