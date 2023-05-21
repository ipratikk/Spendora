//
//  FeaturesViewController.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/23.
//
import Foundation
import UIKit
import RxSwift
import RxCocoa
import Utilities

protocol FeaturesPresentation {
    typealias Input = (
        currentPage: Driver<Int>,
        didTapContinue: Driver<Void>
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

 class FeaturesViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var continueBtn: UIButton!

    private var presenter: FeaturesPresentation!
    var presenterProducer: ((FeaturesPresentation.Input) -> FeaturesPresentation)!


    private let currentPageRelay = PublishSubject<Int>()
    private lazy var currentPageDriver = currentPageRelay.asDriver(onErrorJustReturn: 0).startWith(0)

    private let tapContinueRelay = PublishSubject<Void>()
    private lazy var tapContinueDriver = tapContinueRelay.asDriver(onErrorJustReturn: ())

    private let disposeBag = DisposeBag()

     override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()

         scrollView.subviews.forEach {
             $0.removeFromSuperview()
         }

         presenter.subviews.features
             .drive(onNext: { featureList in
                 self.pageControl.numberOfPages = featureList.count
                 featureList.enumerated().forEach { [weak self] (offset, featureVC) in
                     guard let sself = self else { return }
                     featureVC.frame = CGRect(x: CGFloat(offset) * sself.scrollView.frame.width, y: 0, width: sself.scrollView.frame.width, height: sself.scrollView.frame.height)
                     sself.scrollView.addSubview(featureVC)
                         // Set the content size to enable vertical scrolling
                     let totalWidth = CGFloat(featureList.count) * sself.scrollView.frame.width
                     sself.scrollView.contentSize = CGSize(width: totalWidth, height: featureVC.frame.height)
                 }
             })
             .disposed(by: disposeBag)
     }

    func setupUI() {
        view.backgroundColor = .primaryBackground
        setupPageControl()
        setupScrollView()
        setupContinueBtn()
    }

    func setupBindings() {

        // Input Bindings
        let input = (
            currentPage: currentPageDriver,
            didTapContinue: tapContinueDriver
        )
        presenter = presenterProducer(input)

        // Button Bindings
        continueBtn.rx.tap.bind(to: tapContinueRelay)
            .disposed(by: disposeBag)

        // Output Bindings
        presenter.output.currentPage
            .drive(onNext: { [weak self] currPage in
                guard let sself = self else { return }
                sself.pageControl.currentPage = currPage
                let offsetX = CGFloat(currPage) * sself.scrollView.bounds.width
                sself.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            })
            .disposed(by: disposeBag)
    }

    func setupPageControl() {
        pageControl.isUserInteractionEnabled = false
        pageControl.tintColor = .pageControlTint
        pageControl.currentPageIndicatorTintColor = .pageControlSelected
    }

    func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    func setupContinueBtn() {
        continueBtn.layer.cornerRadius = continueBtn.bounds.height / 2
        continueBtn.backgroundColor = .primaryButton
        continueBtn.setTitle(Module.Strings.continueBtn, for: .normal)
        continueBtn.setTitleColor(.primaryButtonTitle, for: .normal)
        continueBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}

extension FeaturesViewController: UIScrollViewDelegate {
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentOffset.y = 0
        let contentOffset = Float(scrollView.contentOffset.x)
        let width = Float(scrollView.frame.width)
        let currPage = Int(roundf(contentOffset / width)) // round to nearest integer
        currentPageRelay.onNext(currPage)
    }
}
