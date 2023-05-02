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

    @IBOutlet weak var otpField1: UITextField!
    @IBOutlet weak var otpField2: UITextField!
    @IBOutlet weak var otpField3: UITextField!
    @IBOutlet weak var otpField4: UITextField!
    @IBOutlet weak var otpField5: UITextField!
    @IBOutlet weak var otpField6: UITextField!



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
        [otpField1, otpField2, otpField3, otpField4, otpField5, otpField6]
            .forEach { field in
                    // Create a new layer for the bottom border
                let bottomBorder = CALayer()
                bottomBorder.frame = CGRect(x: 0, y: field.frame.size.height - 1, width: field.frame.size.width, height: 1)
                bottomBorder.backgroundColor = UIColor.gray.cgColor

                    // Add the bottom border to the text view's layer
                field.layer.addSublayer(bottomBorder)

                    // Set the text view's border style to none
                field.borderStyle = .none
            }
    }
}
