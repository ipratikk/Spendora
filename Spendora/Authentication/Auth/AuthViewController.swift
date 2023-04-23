//
//  AuthViewController.swift
//  Authentication
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import UIKit
import Utilities
import RxSwift
import RxCocoa

protocol AuthPresentation {
    typealias Output = (
        countryCode: Driver<String>,
        isAuthNumberEnabled: Driver<Bool>
    )

    typealias Input = (
        authNumberTapped: Driver<Void>,
        phoneNumberText: Driver<String>,
        authGoogleTapped: Driver<Void>,
        authAppleTapped: Driver<Void>,
        countryCodeButtonTapped: Driver<Void>
    )

    typealias producer = (Input) -> AuthPresentation

    var output: Output { get }
    var input: Input { get }
}


public class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var authImage: UIImageView!
    @IBOutlet weak var authTitle: UILabel!
    @IBOutlet weak var authSubtitle: UILabel!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var authNumber: UIButton!
    @IBOutlet weak var authOtherTitle: UILabel!
    @IBOutlet weak var authGoogle: CustomButton!
    @IBOutlet weak var authApple: CustomButton!

    @IBOutlet weak var phoneNumberStack: UIStackView!


    private var presenter: AuthPresentation!
    var presenterProducer: ((AuthPresentation.Input) -> AuthPresentation)!


    private let authNumberTapRelay = PublishSubject<Void>()
    private lazy var authNumberTapDriver = authNumberTapRelay.asDriver(onErrorJustReturn: ())

    private let authGoogleTapRelay = PublishSubject<Void>()
    private lazy var authGoogleTapDriver = authGoogleTapRelay.asDriver(onErrorJustReturn: ())

    private let authAppleTapRelay = PublishSubject<Void>()
    private lazy var authAppleTapDriver = authAppleTapRelay.asDriver(onErrorJustReturn: ())

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
        authImage.image = UIImage(named: "signupVector")
        authTitle.text = "Sign up to Spendora"
        authSubtitle.text = "add, manage and analyze your spendings"
        setupCountryCodeBtn()
        phoneNumber.delegate = self
        phoneNumber.placeholder = "Enter phone number"
        phoneNumberStack.layer.cornerRadius = phoneNumberStack.frame.height / 2
        phoneNumberStack.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberStack.layer.borderWidth = 0.5
        setupAuthButton()
        setupAuthOtherBtn()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        phoneNumber.resignFirstResponder()
    }

    func setupBindings() {
        presenter = presenterProducer((
            authNumberTapped: authNumberTapDriver,
            phoneNumberText: phoneNumberTextDriver,
            authGoogleTapped: authGoogleTapDriver,
            authAppleTapped: authAppleTapDriver,
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

        presenter.output.isAuthNumberEnabled
            .drive(onNext:{ [weak self] isEnabled in
                guard let sself = self else { return }
                sself.authNumber.isEnabled = isEnabled
                sself.authNumber.backgroundColor = isEnabled ? UIColor(hex: "#7C15FF") : UIColor(hex: "#7C15FF", alpha: 0.6)
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

    func setupAuthButton() {
        authNumber.layer.cornerRadius = authNumber.frame.height / 2
        authNumber.tintColor = .white
        authNumber.setTitle("Sign up with phone", for: .normal)
        authNumber.addDefaultShadow()
    }

    func setupAuthOtherBtn() {
        authGoogle.setup(with: .google)
        authApple.setup(with: .apple)
    }
}

extension AuthViewController {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}