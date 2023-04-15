//
//  FeaturesViewController.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/23.
//

import UIKit

public class FeaturesViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var continueBtn: UIButton!


    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        setupPageControl()
        setupScrollView()
        setupContinueBtn()
        Feature.all.enumerated().forEach { tuple in
            addFeatureVC(feature: tuple.element, offset: tuple.offset)
        }
    }

    func setupPageControl() {
        pageControl.numberOfPages = Feature.all.count
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
    }

    func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(Feature.all.count), height: scrollView.frame.height)
    }

    func setupContinueBtn() {
        continueBtn.isHidden = true
        continueBtn.layer.cornerRadius = continueBtn.frame.width / 2
        continueBtn.backgroundColor = .black
        continueBtn.setImage(Module.Images.rightArrow, for: .normal)
        continueBtn.tintColor = .white
    }


    func addFeatureVC(feature: Feature, offset: Int) {
        let featureVC = FeatureCardView.loadFromNib()
        featureVC.frame = CGRect(x: CGFloat(offset) * view.frame.width, y: 0, width: view.frame.width, height: scrollView.frame.height)
        featureVC.setup(feature.model)
        scrollView.addSubview(featureVC)
    }

    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.width, y: 0), animated: true)
    }
}

extension FeaturesViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = Float(scrollView.contentOffset.x)
        let width = Float(scrollView.frame.width)
        pageControl.currentPage = Int(floorf(contentOffset / width))
        scrollView.contentOffset.y = 0
        pageControl.isHidden = pageControl.currentPage == Feature.all.count - 1
        continueBtn.isHidden = pageControl.currentPage != Feature.all.count - 1
    }
}
