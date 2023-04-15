//
//  TncPrivacyViewController.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/23.
//

import UIKit

public enum TncType {
    case privacy
    case tnc
}

class TncPrivacyViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    var tncType: TncType = .privacy

    override func viewDidLoad() {
        super.viewDidLoad()
        switch tncType {
        case .privacy:
                textView.attributedText = getText(type: .privacy)
        case .tnc:
                textView.attributedText = getText(type: .tnc)
        }
    }

    func setup(type: TncType) {
        tncType = type
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true)
    }

    func getText(type: TncType) -> NSAttributedString {
        var termsAndConditionsText = ""
        switch type {
            case .tnc:
                termsAndConditionsText = Module.Strings.termsAndConditions
            case .privacy:
                termsAndConditionsText = Module.Strings.privacyPolicy
        }
        let attributedString = NSMutableAttributedString(string: termsAndConditionsText)

            // Set attributes for the entire string
        let font = UIFont.systemFont(ofSize: 14)
        let color = UIColor.black
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))

            // Set attributes for the date
        let dateRange = (termsAndConditionsText as NSString).range(of: Module.Strings.termsAndConditionsLastUpdated)
        let dateFont = UIFont.systemFont(ofSize: 12)
        let dateAttributes: [NSAttributedString.Key: Any] = [.font: dateFont, .foregroundColor: color]
        attributedString.addAttributes(dateAttributes, range: dateRange)

            // Set attributes for the email address
        let emailRange = (termsAndConditionsText as NSString).range(of: Module.Strings.termsAndConditionsEmail)
        let linkAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]
        attributedString.addAttributes(linkAttributes, range: emailRange)

        return attributedString
    }

}
