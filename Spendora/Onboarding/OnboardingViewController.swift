//
//  OnboardingViewController.swift
//  Spendora
//
//  Created by Pratik Goel on 10/04/23.
//

import UIKit

class OnboardingViewController: UIViewController {

        // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animatiomView: UIView!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var tncLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!

        // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
        startBtn.backgroundColor = .black
        startBtn.layer.cornerRadius = 25
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.setTitle(Module.Strings.getStarted, for: .normal)
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        startBtn.addTarget(self, action: #selector(startBtnClicked), for: .touchUpInside)
    }

    @objc func startBtnClicked() {
        guard checkbox.isSelected else {
            let alert = UIAlertController(title: .empty, message: Module.Strings.Alert.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: .ok, style: .default))
            present(alert, animated: true)
            return
        }
        setOnboardingCompleted()
    }

    func setOnboardingCompleted() {
        let defaults = UserDefaults.standard
        defaults.setValue(true, forKey: Constants.UserdefaultKeys.isOnboarded.rawValue)
    }

    private func setupCheckBox() {
        checkbox.setImage(Module.Images.unchecked, for: .normal)
        checkbox.setImage(Module.Images.checked, for: .selected)

    }

    @IBAction func checkboxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    private func setupTncLabel() {
        tncLabel.numberOfLines = 0
        tncLabel.lineBreakMode = .byWordWrapping
        let termsAndConditions = Module.Strings.tncText
        let attributedString = NSMutableAttributedString(string: termsAndConditions)
            // Set attributes for the entire string
        let font = UIFont.systemFont(ofSize: 17)
        let color = UIColor.black
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
                                          y: (label.bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        if let link = label.attributedText?.attribute(.link, at: indexOfCharacter, effectiveRange: nil) as? String {
                // Handle tapping on link
            switch link {
            case "terms":
                    // Show Terms and Conditions view
                let termsVC = TncPrivacyViewController(tncType: .tnc)
                navigationController?.present(termsVC, animated: true)
            case "privacy":
                    // Show Privacy Policy view
                let privacyVC = TncPrivacyViewController(tncType: .privacy)
                navigationController?.present(privacyVC, animated: true)
            default:
                break
            }
        }
    }

    func setupUI() {
        [titleLabel, animatiomView, startBtn, tncLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupAnimationView()
        setupStartBtn()
        setupTncLabel()
        setupCheckBox()
    }
}
