//
//  OTPViewController.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 29/04/23.
//

import UIKit
import Utilities

class OTPViewController: UIViewController {

    @IBOutlet weak var otpImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var resendTitle: UILabel!
    @IBOutlet weak var submitBtn: UIButton!

    @IBOutlet weak var otpField: UITextField!



    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    deinit {
        removeKeyboardNotification()
        print("\(#file) Deinit Called")
    }

    func setupUI() {
        setupOTPImage()
        setupOTPTitle()
        setupOTPSubtitle()
        setupOTPFields()
        setupResendTitle()
        setupSubmitBtn()
        addKeyboardNotification()
    }

    func setupOTPImage() {
        otpImageView.image = UIImage(named: "otpSecureEntry")
    }

    func setupOTPTitle() {
        titleLabel.text = "Verify Phone Number"
    }

    func setupOTPSubtitle() {
        let phoneNumber = "+919051481667"
        var message = "Please enter the 6 digit code sent to {phoneNumber} through SMS"
        message = message.replacingOccurrences(of: "{phoneNumber}", with: phoneNumber)
        let attributedString = NSMutableAttributedString(string: message)
        let placeholderAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        let range = (message as NSString).range(of: phoneNumber)
        attributedString.addAttributes(placeholderAttrs, range: range)
        subtitleLabel.attributedText = attributedString
    }


    func setupResendTitle() {
        let attributedString = NSMutableAttributedString(string: "Didn't receive a code? Resend SMS")
        let range = (attributedString.string as NSString).range(of: "Resend SMS")
        attributedString.addAttribute(.link, value: "retryOTP", range: range)

        resendTitle.attributedText = attributedString

            // Add a tap gesture recognizer to the label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        resendTitle.isUserInteractionEnabled = true
        resendTitle.addGestureRecognizer(tapGesture)
    }

    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let attributedText = resendTitle.attributedText else { return }
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

            // Get the location of the tap in the label
        let location = gesture.location(in: resendTitle)

            // Determine the index of the character that was tapped
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

            // Get the value of the link attribute at the tapped character index
        if let urlString = attributedText.attribute(.link, at: characterIndex, effectiveRange: nil) as? String,
           urlString == "retryOTP" {
            retryOTP()
        }
    }

    func retryOTP() {
            // Handle retry OTP logic here
        print("Retry OTP")
    }

    func setupSubmitBtn() {
        submitBtn.setTitle("Verify Number", for: .normal)
        submitBtn.backgroundColor = .black
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
        submitBtn.addDefaultShadow()
    }

    func setupOTPFields() {

        // Create a new layer for the bottom border
        otpField.delegate = self
        updateAttrText("", textField: otpField)
        updateAttrText("XXXXXX", textField: otpField, placeholder: true)
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: otpField.frame.size.height - 1, width: otpField.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.gray.cgColor

            // Add the bottom border to the text view's layer
        otpField.layer.addSublayer(bottomBorder)

            // Set the text view's border style to none
        otpField.borderStyle = .none
    }
}

extension OTPViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            // Check if the text field is the same as the one that triggered the event
        guard textField == otpField else {
            return true
        }

            // Get the current text and calculate the new length
        guard let currentText = textField.text else {
            return true
        }
        let newLength = currentText.count + string.count - range.length

            // Check if the new length is within the allowed range
        if newLength > 6 {
            return false
        }

            // Create an attributed string with the updated text
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        updateAttrText(newText, textField: textField)

            // Return false to prevent the text field from updating its text
        return false
    }

    func updateAttrText(_ newText: String, textField: UITextField, placeholder: Bool = false) {
        let attributedString = NSMutableAttributedString(string: newText)

            // Set the character spacing to 1.5 points
        let kernAttrs: [NSAttributedString.Key: Any] = [
            .kern: placeholder ? 13.0: 15.0,
            .font: UIFont.boldSystemFont(ofSize: 27)
        ]
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes(kernAttrs, range: range)

            // Set the attributed string as the text of the UITextField
        if placeholder {
            textField.attributedPlaceholder = attributedString
        } else {
            textField.attributedText = attributedString
        }
    }
}
