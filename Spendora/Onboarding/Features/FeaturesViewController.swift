//
//  FeaturesViewController.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol FeaturesPresentation {
    typealias Input = (
        currentPage: Driver<Int>,
        didTapSignup: Driver<Void>,
        didTapSignin: Driver<Void>
    )

    typealias Output = (
        features: Driver<[Feature]>,
        currentPage: Driver<Int>
    )

    typealias Subviews = (
        features: Driver<[UIView]>,
        ()
    )

    typealias producer = (Input) -> FeaturesPresentation

    var output: Output { get }
    var input: Input { get }
    var subviews: Subviews { get }
}

public class FeaturesViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!

    private var presenter: FeaturesPresentation!
    var presenterProducer: ((FeaturesPresentation.Input) -> FeaturesPresentation)!


    private let currentPageRelay = PublishSubject<Int>()
    private lazy var currentPageDriver = currentPageRelay.asDriver(onErrorJustReturn: 0).startWith(0)

    private let tapSignupRelay = PublishSubject<Void>()
    private lazy var tapSignupDriver = tapSignupRelay.asDriver(onErrorJustReturn: ())

    private let tapSigninRelay = PublishSubject<Void>()
    private lazy var tapSigninDriver = tapSigninRelay.asDriver(onErrorJustReturn: ())

    private let disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    func setupUI() {
        setupPageControl()
        setupScrollView()
        setupSignupBtn()
        setupSigninBtn()
    }

    func setupBindings() {

        // Input Bindings
        let input = (
            currentPage: currentPageDriver,
            didTapSignup: tapSignupDriver,
            didTapSignin: tapSigninDriver
        )
        presenter = presenterProducer(input)

        // Button Bindings
        signupBtn.rx.tap.bind(to: tapSignupRelay)
            .disposed(by: disposeBag)
        signinBtn.rx.tap.bind(to: tapSigninRelay)
            .disposed(by: disposeBag)

        // Output Bindings
        presenter.output.features
            .drive(onNext: { [weak self] features in
                guard let sself = self else { return }
                sself.pageControl.numberOfPages = features.count
                sself.scrollView.contentSize = CGSize(width: sself.view.frame.width * CGFloat(features.count), height: sself.scrollView.frame.height)
            })
            .disposed(by: disposeBag)

        presenter.output.currentPage
            .drive(onNext: { [weak self] currPage in
                guard let sself = self else { return }
                sself.pageControl.currentPage = currPage
                let offsetX = CGFloat(currPage) * sself.scrollView.bounds.width
                sself.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            })
            .disposed(by: disposeBag)

        presenter.subviews.features
            .drive(onNext: { featureList in
                featureList.enumerated().forEach { [weak self] (offset,featureVC) in
                    guard let sself = self else { return }
                    sself.scrollView.addSubview(featureVC)
                    featureVC.frame = CGRect(x: CGFloat(offset) * sself.view.frame.width, y: 0, width: sself.view.frame.width, height: sself.scrollView.frame.height)
                }
            })
            .disposed(by: disposeBag)
    }

    func setupPageControl() {
        pageControl.isUserInteractionEnabled = false
    }

    func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    func setupSignupBtn() {
        signupBtn.layer.cornerRadius = 25
        signupBtn.backgroundColor = .black
        signupBtn.tintColor = .white
        signupBtn.setTitle(Module.Strings.signupBtn, for: .normal)
    }

    func setupSigninBtn() {
        signinBtn.tintColor = .black
        signinBtn.setTitle(Module.Strings.signinBtn, for: .normal)
    }
}

extension FeaturesViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0
        let contentOffset = Float(scrollView.contentOffset.x)
        let width = Float(scrollView.frame.width)
        let currPage = Int(roundf(contentOffset / width)) // round to nearest integer
        currentPageRelay.onNext(currPage)
    }
}
