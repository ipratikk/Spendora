//
//  OTPViewController.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 29/04/23.
//

import UIKit
import Utilities
import RxSwift
import RxCocoa

protocol OTPPresentation {
    typealias Input = (
        resendOTP: Driver<Void>,
        otpCode: Driver<[String]>,
        didTapContinue: Driver<Void>
    )

    typealias Output = (
        phoneNumber: Driver<String>,
        isVerfifyOTPEnabled: Driver<Bool>
    )

    typealias producer = (Input) -> OTPPresentation

    var output: Output { get }
    var input: Input { get }
}


class OTPViewController: UIViewController, OTPTextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var otpImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var resendTitle: UILabel!
    @IBOutlet weak var submitBtn: UIButton!

    @IBOutlet weak var otpField1: OTPTextField!
    @IBOutlet weak var otpField2: OTPTextField!
    @IBOutlet weak var otpField3: OTPTextField!
    @IBOutlet weak var otpField4: OTPTextField!
    @IBOutlet weak var otpField5: OTPTextField!
    @IBOutlet weak var otpField6: OTPTextField!

    private var presenter: OTPPresentation!
    var presenterProducer: ((OTPPresentation.Input) -> OTPPresentation)!

    public var fieldsCount: Int = 6
    var secureDataEntry: [String] = Array(repeating: "", count: 6)
    let shouldAllowIntermediateEditing: Bool = false
    var otpTimeoutTimer: Timer?
    var otpTimeoutLimit: Int = 30
    var otpTimeout: Int = 30


    private let resendOTPRelay = PublishSubject<Void>()
    private lazy var resendOTPDriver = resendOTPRelay.asDriver(onErrorJustReturn: ())

    private let otpCodeRelay = PublishSubject<[String]>()
    private lazy var otpCodeDriver = otpCodeRelay.asDriver(onErrorJustReturn: [])

    private let tapContinueRelay = PublishSubject<Void>()
    private lazy var tapContinueDriver = tapContinueRelay.asDriver(onErrorJustReturn: ())

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        otpField1.becomeFirstResponder()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    deinit {
        removeKeyboardNotification()
    }

    func setupUI() {
        setupOTPImage()
        setupOTPTitle()
        setupOTPFields()
        startOTPTimeout()
        setupSubmitBtn()
        addKeyboardNotification(with: scrollView)
    }

    func setupBindings() {
        let input = (
            resendOTP: resendOTPDriver,
            otpCode: otpCodeDriver,
            didTapContinue: tapContinueDriver
        )
        presenter = presenterProducer(input)

        presenter.output.phoneNumber
            .drive(onNext: { [weak self] phoneNumber in
                guard let sself = self else { return }
                sself.setupOTPSubtitle(with: phoneNumber)
            })
            .disposed(by: disposeBag)

        presenter.output.isVerfifyOTPEnabled
            .drive(onNext:{ [weak self] isEnabled in
                guard let sself = self else { return }
                sself.submitBtn.isEnabled = isEnabled
                sself.submitBtn.backgroundColor = isEnabled ? .black : .black.withAlphaComponent(0.6)
                sself.submitBtn.setTitleColor(.white, for: [.normal, .disabled])
            })
            .disposed(by: disposeBag)
    }

    func setupOTPImage() {
        otpImageView.image = Module.OTP.Images.otpImage
    }

    func setupOTPTitle() {
        titleLabel.text = Module.OTP.Strings.title
    }

    func setupOTPSubtitle(with phoneNumber: String) {
        let message = String(format: Module.OTP.Strings.subtitle, phoneNumber)
        let attributedString = getAttributedString(
            from: message,
            with: phoneNumber,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]
        )
        subtitleLabel.attributedText = attributedString
    }

    func startOTPTimeout() {
        setupResendTimeoutTitle(otpTimeout)
        otpTimeoutTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let sself = self else { return }
            sself.otpTimeout -= 1
            if sself.otpTimeout == 0 {
                sself.otpTimeoutTimer?.invalidate()
                sself.setupResendTitle()
            } else {
                sself.setupResendTimeoutTitle(sself.otpTimeout)
            }
        }
    }

    func setupResendTitle() {
        let attributedString = getAttributedString(
            from: Module.OTP.Strings.resendTitle,
            with: Module.OTP.Strings.resendPlaceholder,
            attributes: [
                .link: "retryOTP"
            ]
        )
        resendTitle.attributedText = attributedString
            // Add a tap gesture recognizer to the label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        resendTitle.isUserInteractionEnabled = true
        resendTitle.addGestureRecognizer(tapGesture)
    }

    func setupResendTimeoutTitle(_ time: Int) {
        let timeoutString = String(format: Module.OTP.Strings.resendTimeout, time)
        let resendString = String(format: Module.OTP.Strings.resendTimeoutPlaceholder, time)
        let attrString = getAttributedString(
            from: timeoutString,
            with: resendString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .light),
                .foregroundColor: UIColor.lightGray
            ]
        )
        resendTitle.attributedText = attrString
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
        resendOTPRelay.onNext(())
        otpTimeoutTimer?.invalidate()
        otpTimeout = otpTimeoutLimit
        startOTPTimeout()
    }

    func setupSubmitBtn() {
        submitBtn.setTitle(Module.OTP.Strings.verify, for: .normal)
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
        submitBtn.addDefaultShadow()
        submitBtn.rx.tap.bind(to: tapContinueRelay)
            .disposed(by: disposeBag)
    }

    func setupOTPFields() {

            // Create a new layer for the bottom border
        [otpField1, otpField2, otpField3, otpField4, otpField5, otpField6]
            .forEach {
                $0.otpDelegate = self
                $0.delegate = self
                let bottomBorder = CALayer()
                bottomBorder.frame = CGRect(x: 0, y: $0.frame.size.height - 1, width: $0.frame.size.width, height: 1)
                bottomBorder.backgroundColor = UIColor.gray.cgColor

                    // Add the bottom border to the text view's layer
                $0.layer.addSublayer(bottomBorder)

                    // Set the text view's border style to none
                $0.borderStyle = .none
            }
    }

    func disableViews(){
        DispatchQueue.main.async {
            for i in 1001...1006 {
                if let prevOTPField = self.view.viewWithTag(i) as? UITextField {
                    prevOTPField.isUserInteractionEnabled =   false
                    prevOTPField.isEnabled =  false
                }
            }
            self.submitBtn.isEnabled = false
        }
    }

    func enableViews(isError: Bool){
        DispatchQueue.main.async {
            for i in 1001...1006 {
                if let prevOTPField = self.view.viewWithTag(i) as? UITextField {
                    prevOTPField.isUserInteractionEnabled =  true
                    prevOTPField.isEnabled = true
                }
            }
            self.submitBtn.isEnabled  =  true
        }
    }
}

extension OTPViewController: UITextFieldDelegate {

    fileprivate func isPreviousFieldsEntered(forTextField textField: UITextField) -> Bool {
        var isTextFilled = true
        var nextOTPField: UITextField?

            // If intermediate editing is not allowed, then check for last filled field in forward direction.
        for index in stride(from: 1, to: fieldsCount + 1, by: 1) {
            let tempNextOTPField = self.view.viewWithTag( index + 1000 ) as? UITextField

            if let tempNextOTPFieldText = tempNextOTPField?.text, tempNextOTPFieldText.isEmpty {
                nextOTPField = tempNextOTPField
                break
            }
        }
        if let nextOTPField = nextOTPField {
            isTextFilled = (nextOTPField == textField || (textField.tag) == (nextOTPField.tag - 1))
        }
        return isTextFilled
    }

    func textFieldDidDelete() {
            // Delete character from current active OTP field and set that to 1st responder
        for index in stride(from: 1, to: fieldsCount + 1, by: 1) {
            let curOTP = self.view.viewWithTag(index + 1000) as? UITextField
            if let curOTP = curOTP {
                if curOTP.isFirstResponder{
                    deleteTextInTextField(in: curOTP)
                    break
                }
            }
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isPreviousFieldsEntered(forTextField: textField)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let replacedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""


        if replacedText.count >= 1 {
                // Enter character only if the current OTP field is empty (edge case for last character overflow)
            if textField.tag <= fieldsCount + 1000 && textField.text == "" {
                secureDataEntry[textField.tag - 1001] = string
                textField.text = string
                otpCodeRelay.onNext(secureDataEntry)
            }

            let nextOTPField = self.view.viewWithTag(textField.tag + 1)

            if let nextOTPField = nextOTPField {
                nextOTPField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else {
            deleteTextInTextField(in: textField)
        }
        return false
    }

    private func deleteTextInTextField(in textField : UITextField) {
        let currentText = textField.text ?? ""

            // On Delete, Move to previous OTP field only if the current field is empty
        if textField.tag > 1001 && currentText.isEmpty {
            if let prevOTPField = self.view.viewWithTag(textField.tag - 1) as? UITextField {
                deleteText(in: prevOTPField)
            }
        } else {
            deleteText(in: textField)
        }
    }

    private func deleteText(in textField: UITextField) {
            // If deleting the text, set the current textfield as active for next input
        secureDataEntry[textField.tag - 1001] = ""
        otpCodeRelay.onNext(secureDataEntry)
        textField.text = ""
        textField.becomeFirstResponder()
    }
}
