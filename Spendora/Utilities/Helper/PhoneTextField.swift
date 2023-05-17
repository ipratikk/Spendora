//
//  PhoneTextField.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 12/05/23.
//

import Foundation
import UIKit

public class PhoneTextField: UITextField {

    private let maxLength = 10

    public override func awakeFromNib() {
        super.awakeFromNib()
        keyboardType = .phonePad
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return true
    }

    @objc func textDidChange() {
        guard let text = text else { return }
        let filteredText = String(text.filter("0123456789".contains))

        if filteredText.count >= maxLength {
            let formattedText = String(filteredText.suffix(maxLength))
            self.text = formattedText
            endEditing(true)
        } else {
            self.text = filteredText
        }
    }
}
