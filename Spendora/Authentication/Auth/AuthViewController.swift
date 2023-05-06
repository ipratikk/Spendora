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
        countryCode: Driver<Country?>,
        isAuthNumberEnabled: Driver<Bool>,
        authType: Driver<AuthType>
    )

    typealias Input = (
        authNumberTapped: Driver<Void>,
        phoneNumberText: Driver<String>,
        authGoogleTapped: Driver<Void>,
        authAppleTapped: Driver<Void>,
        countryCodeButtonTapped: Driver<Void>,
        authType: Driver<AuthType>
    )

    typealias producer = (Input) -> AuthPresentation

    var output: Output { get }
    var input: Input { get }
}


class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
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

    private let authTypeRelay = BehaviorRelay<AuthType>(value: .signup)
    private lazy var authTypeDriver = authTypeRelay.asDriver(onErrorJustReturn: .signup)

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

    private var currentAuthType: AuthType = .signup


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    func setupUI() {
        phoneNumber.delegate = self
        countryCodeBtn.setTitle(Module.Auth.Strings.countryCode ,for: .normal)
        phoneNumberStack.layer.cornerRadius = phoneNumberStack.frame.height / 2
        phoneNumberStack.clipsToBounds = true
        [phoneNumberStack,countryCodeBtn].forEach {
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 0.5
        }
        setupNavigationBarAuthButton()
        setupAuthButton()
        setupAuthOtherBtn()
        addKeyboardNotification(with: scrollView)
    }

    deinit {
        removeKeyboardNotification()
        print("\(#file) Deinit Called")
    }

    func setupBindings() {
        presenter = presenterProducer((
            authNumberTapped: authNumberTapDriver,
            phoneNumberText: phoneNumberTextDriver,
            authGoogleTapped: authGoogleTapDriver,
            authAppleTapped: authAppleTapDriver,
            countryCodeButtonTapped: countryCodeBtnTapDriver,
            authType: authTypeDriver
        ))

        presenter.output.authType
            .drive(authTypeRelay)
            .disposed(by: disposeBag)


        authTypeDriver
            .distinctUntilChanged()
            .drive(onNext: { [weak self] authType in
                guard let sself = self else { return }
                print("Auth Type Driver triggered")
                UIView.transition(with: sself.view, duration: 0.5, options: [.transitionCrossDissolve, .preferredFramesPerSecond60]) {
                    sself.setupStrings(for: authType)
                    sself.currentAuthType = authType
                }
            })
            .disposed(by: disposeBag)

        countryCodeBtn.rx.tap.bind(to: countryCodeBtnTapRelay)
            .disposed(by: disposeBag)

        phoneNumber.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: phoneNumberTextRelay)
            .disposed(by: disposeBag)

        presenter.output.countryCode
            .drive(onNext:{ [weak self] country in
                guard let sself = self else { return }
                guard let country = country else { return }
                let title = country.getFlag() + " " + country.code
                sself.countryCodeBtn.setTitle(title, for: .normal)
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

    func setupNavigationBarAuthButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Module.Auth.Strings.signin, style: .done, target: self, action: #selector(barButtonTapped))
    }

    @objc func barButtonTapped(_ sender: Any) {
        switch currentAuthType {
            case .signup:
                authTypeRelay.accept(.signin)
            case .signin:
                authTypeRelay.accept(.signup)
        }
    }

    func setupStrings(for authType: AuthType) {
        authTitle.text = String(format: Module.Auth.Strings.title, authType.rawValue)
        authSubtitle.text = Module.Auth.Strings.subtitle
        phoneNumber.placeholder = Module.Auth.Strings.placeholder
        authNumber.setTitle(String(format: Module.Auth.Strings.numButton, authType.rawValue), for: .normal)
        authOtherTitle.text = String(format: Module.Auth.Strings.otherTitle, authType.rawValue)
        switch authType {
            case .signup:
                navigationItem.rightBarButtonItem?.title = AuthType.signin.rawValue
                authImage.image = Module.Auth.Images.signupImage
            case .signin:
                navigationItem.rightBarButtonItem?.title = AuthType.signup.rawValue
                authImage.image = Module.Auth.Images.signinImage
        }
        authTypeRelay.accept(authType)
    }

    func setupAuthButton() {
        authNumber.layer.cornerRadius = authNumber.frame.height / 2
        authNumber.tintColor = .white
        authNumber.addDefaultShadow()
        authNumber.rx.tap.bind(to: authNumberTapRelay)
            .disposed(by: disposeBag)
    }

    func setupAuthOtherBtn() {
        authGoogle.setup(with: .google)
        authGoogle.rx.tap.bind(to: authGoogleTapRelay)
            .disposed(by: disposeBag)
        authApple.setup(with: .apple)
        authApple.rx.tap.bind(to: authAppleTapRelay)
            .disposed(by: disposeBag)
    }
}

extension AuthViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).filter("0123456789".contains)
            if updatedText.count >= 10 {
                let newText = String(updatedText.suffix(10))
                textField.text = newText
                view.endEditing(true)
                return false
            } else {
                textField.text = updatedText
            }
        }

        return false
    }
}
