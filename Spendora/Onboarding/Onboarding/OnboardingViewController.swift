//
//  OnboardingViewController.swift
//  Spendora
//
//  Created by Pratik Goel on 10/04/23.
//

import UIKit
import Utilities
import RxSwift
import RxCocoa

protocol OnboardingPresentation {
    typealias Input = (
        tapTncLabel: Driver<String>,
        isCheckboxSelected: Driver<Bool>,
        clickStartBtn: Driver<Void>
    )

    typealias Producer = (Input) -> OnboardingPresentation
}

class OnboardingViewController: UIViewController {

        // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animatiomView: UIView!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var tncLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!

    private var presenter: OnboardingPresentation!
    var presenterProducer: ((OnboardingPresentation.Input) -> OnboardingPresentation)!

    private let tapTncLabelRelay = PublishSubject<String>()
    private lazy var tapTncLabelDriver = tapTncLabelRelay.asDriver(onErrorDriveWith: Driver.empty())

    private let isCheckBoxSelectedRelay = PublishSubject<Bool>()
    private lazy var isCheckBoxSelectedDriver = isCheckBoxSelectedRelay.asDriver(onErrorJustReturn: false).startWith(false)

    private let clickStartBtnRelay = PublishSubject<Void>()
    private lazy var clickStartBtnDriver = clickStartBtnRelay.asDriver(onErrorDriveWith: Driver.empty())

    private let disposeBag = DisposeBag()

        // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = presenterProducer((
            tapTncLabel: tapTncLabelDriver,
            isCheckboxSelected: isCheckBoxSelectedDriver,
            clickStartBtn: clickStartBtnDriver
        ))
        setupUI()
    }

        // MARK: - Private Methods

    private func setupAnimationView() {
        let animation = Module.Animations.finance
        let lottieView = LottieView(frame: animatiomView.bounds)
        lottieView.setup(animation: animation)
        animatiomView.addSubview(lottieView)
        lottieView.play()
    }

    private func setupStartBtn() {
        startBtn.backgroundColor = .primaryButton
        startBtn.layer.cornerRadius = startBtn.bounds.height / 2
        startBtn.setTitleColor(.primaryButtonTitle, for: .normal)
        startBtn.setTitle(Module.Strings.getStarted, for: .normal)
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        startBtn.rx.tap.bind(to: clickStartBtnRelay)
            .disposed(by: disposeBag)
    }

    private func setupCheckBox() {
        checkbox.setImage(Module.Images.unchecked, for: .normal)
        checkbox.setImage(Module.Images.checked, for: .selected)
    }

    @IBAction func checkboxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isCheckBoxSelectedRelay.onNext(sender.isSelected)
    }

    private func setupTncLabel() {
        tncLabel.numberOfLines = 0
        tncLabel.lineBreakMode = .byWordWrapping
        let termsAndConditions = Module.Strings.tncText
        let attributedString = NSMutableAttributedString(string: termsAndConditions)
            // Set attributes for the entire string
        let font = UIFont.systemFont(ofSize: 17)
        let color: UIColor = .label
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: termsAndConditions.count))

        let tncRange = (termsAndConditions as NSString).range(of: Module.Strings.tncTnc)
        attributedString.addAttribute(.link, value: "terms", range: tncRange)

        let privacyRange = (termsAndConditions as NSString).range(of: Module.Strings.tncPrivacy)
        attributedString.addAttribute(.link, value: "privacy", range: privacyRange)

        tncLabel.attributedText = attributedString
        tncLabel.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel))
        tncLabel.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapOnLabel(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        let locationOfTouchInLabel = sender.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (label.bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX,
                                          y: (label.bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        if let link = label.attributedText?.attribute(.link, at: indexOfCharacter, effectiveRange: nil) as? String {
            tapTncLabelRelay.onNext(link)
        }
    }

    func setupUI() {
        view.backgroundColor = .primaryBackground
        [titleLabel, animatiomView, startBtn, tncLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupAnimationView()
        setupStartBtn()
        setupTncLabel()
        setupCheckBox()
    }
}
