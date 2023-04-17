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
        didTapContinue: Driver<Void>
    )

    typealias Output = (
        features: Driver<[Feature]>,
        currentPage: Driver<Int>,
        isLastPage: Driver<Bool>
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
    @IBOutlet weak var continueBtn: UIButton!

    private var presenter: FeaturesPresentation!
    var presenterProducer: ((FeaturesPresentation.Input) -> FeaturesPresentation)!


    private let currentPageRelay = PublishSubject<Int>()
    private lazy var currentPageDriver = currentPageRelay.asDriver(onErrorJustReturn: 0).startWith(0)

    private let tapContinueRelay = PublishSubject<Void>()
    private lazy var tapContinueDriver = tapContinueRelay.asDriver(onErrorJustReturn: ())

    private let disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    func setupUI() {
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


        presenter.output.isLastPage
            .drive(onNext: { [weak self] isLast in
                guard let sself = self else { return }
                sself.pageControl.isHidden = isLast
                sself.continueBtn.isHidden = !isLast
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

    func setupContinueBtn() {
        continueBtn.isHidden = true
        continueBtn.layer.cornerRadius = continueBtn.frame.width / 2
        continueBtn.backgroundColor = .black
        continueBtn.setImage(Module.Images.rightArrow, for: .normal)
        continueBtn.tintColor = .white
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
