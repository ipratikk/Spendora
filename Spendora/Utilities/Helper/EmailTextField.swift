//
//  EmailTextField.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 12/05/23.
//

import Foundation
import UIKit

public class EmailTextField: UITextField {

    private let maxLength = 254

    public override func awakeFromNib() {
        super.awakeFromNib()
        keyboardType = .emailAddress
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return true
    }

    @objc func textDidChange() {
        guard let text = text else { return }
        let filteredText = String(text.filter("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._-".contains))

        if filteredText.count >= maxLength {
            let endIndex = filteredText.index(filteredText.startIndex, offsetBy: maxLength)
            let formattedText = String(filteredText[..<endIndex])
            self.text = formattedText
            endEditing(true)
        } else {
            self.text = filteredText
        }
    }
}
