//
//  SignupViewController.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import UIKit
import Utilities
import RxSwift
import RxCocoa

protocol SignupPresentation {
    typealias Output = (
        countryCode: Driver<String>,
        isSignupNumberEnabled: Driver<Bool>
    )

    typealias Input = (
        signupNumberTapped: Driver<Void>,
        phoneNumberText: Driver<String>,
        signupGoogleTapped: Driver<Void>,
        signupAppleTapped: Driver<Void>,
        countryCodeButtonTapped: Driver<Void>
    )

    typealias producer = (Input) -> SignupPresentation

    var output: Output { get }
    var input: Input { get }
}


public class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signupImage: UIImageView!
    @IBOutlet weak var signupTitle: UILabel!
    @IBOutlet weak var signupSubtitle: UILabel!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var signupNumber: UIButton!
    @IBOutlet weak var signupOtherTitle: UILabel!
    @IBOutlet weak var signupGoogle: CustomButton!
    @IBOutlet weak var signupApple: CustomButton!

    @IBOutlet weak var phoneNumberStack: UIStackView!


    private var presenter: SignupPresentation!
    var presenterProducer: ((SignupPresentation.Input) -> SignupPresentation)!


    private let signupNumberTapRelay = PublishSubject<Void>()
    private lazy var signupNumberTapDriver = signupNumberTapRelay.asDriver(onErrorJustReturn: ())

    private let signupGoogleTapRelay = PublishSubject<Void>()
    private lazy var signupGoogleTapDriver = signupGoogleTapRelay.asDriver(onErrorJustReturn: ())

    private let signupAppleTapRelay = PublishSubject<Void>()
    private lazy var signupAppleTapDriver = signupAppleTapRelay.asDriver(onErrorJustReturn: ())

    private let countryCodeBtnTapRelay = PublishSubject<Void>()
    private lazy var countryCodeBtnTapDriver = countryCodeBtnTapRelay.asDriver(onErrorJustReturn: ())

    private let phoneNumberTextRelay = PublishSubject<String>()
    private lazy var phoneNumberTextDriver = phoneNumberTextRelay.asDriver(onErrorJustReturn: "")

    private let disposeBag = DisposeBag()


    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    func setupUI() {
        signupImage.image = UIImage(named: "signupVector")
        signupTitle.text = "Sign up to Spendora"
        signupSubtitle.text = "add, manage and analyze your spendings"
        setupCountryCodeBtn()
        phoneNumber.delegate = self
        phoneNumber.placeholder = "Enter phone number"
        phoneNumberStack.layer.cornerRadius = phoneNumberStack.frame.height / 2
        phoneNumberStack.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberStack.layer.borderWidth = 0.5
        setupSignupButton()
        setupSignupOtherBtn()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        phoneNumber.resignFirstResponder()
    }

    func setupBindings() {
        presenter = presenterProducer((
            signupNumberTapped: signupNumberTapDriver,
            phoneNumberText: phoneNumberTextDriver,
            signupGoogleTapped: signupGoogleTapDriver,
            signupAppleTapped: signupAppleTapDriver,
            countryCodeButtonTapped: countryCodeBtnTapDriver
        ))

        countryCodeBtn.rx.tap.bind(to: countryCodeBtnTapRelay)
            .disposed(by: disposeBag)

        phoneNumber.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: phoneNumberTextRelay)
            .disposed(by: disposeBag)

        presenter.output.countryCode
            .drive(onNext:{ [weak self] code in
                guard let sself = self else { return }
                sself.countryCodeBtn.setTitle(code, for: .normal)
            })
            .disposed(by: disposeBag)

        presenter.output.isSignupNumberEnabled
            .drive(onNext:{ [weak self] isEnabled in
                guard let sself = self else { return }
                sself.signupNumber.isEnabled = isEnabled
                sself.signupNumber.backgroundColor = isEnabled ? UIColor(hex: "#7C15FF") : UIColor(hex: "#7C15FF", alpha: 0.6)
            })
            .disposed(by: disposeBag)
    }

    func setupCountryCodeBtn() {
        countryCodeBtn.addTarget(self, action: #selector(showView), for: .touchUpInside)
    }

    @objc func showView() {
        let vc = CountryCodeViewController.initFromNib()
        let navController = UINavigationController(rootViewController: vc)
        if let sheets = vc.sheetPresentationController {
            sheets.detents = [.medium()]
        }
        present(navController, animated: true)
    }

    func setupSignupButton() {
        signupNumber.layer.cornerRadius = signupNumber.frame.height / 2
        signupNumber.tintColor = .white
        signupNumber.setTitle("Sign up with phone", for: .normal)
        signupNumber.addDefaultShadow()
    }

    func setupSignupOtherBtn() {
        signupGoogle.setup(with: .google)
        signupApple.setup(with: .apple)
    }
}

extension SignupViewController {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
