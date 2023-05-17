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


class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var authImage: UIImageView!
    @IBOutlet weak var authTitle: UILabel!
    @IBOutlet weak var authSubtitle: UILabel!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var phoneNumber: PhoneTextField!
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
        setupStrings()
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

    func setupStrings() {
        authTitle.text = Module.Auth.Strings.title
        authSubtitle.text = Module.Auth.Strings.subtitle
        phoneNumber.placeholder = Module.Auth.Strings.placeholder
        authNumber.setTitle(Module.Auth.Strings.numButton, for: .normal)
        authOtherTitle.text = Module.Auth.Strings.otherTitle
        authImage.image = Module.Auth.Images.authImage
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
