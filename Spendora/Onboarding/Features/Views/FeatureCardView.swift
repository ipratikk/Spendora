//
//  FeatureCardView.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/23.
//

import UIKit
import Utilities

private let featureCardView = "FeatureCardView"

class FeatureCardView: UIView, NibLoadable {

    private(set) static var nibName: String = featureCardView

    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!

    var lottieView: LottieView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lottieView = LottieView(frame: animationView.bounds)
        animationView.addSubview(lottieView)
    }

    func setup(_ featureModel: FeatureModel) {
        lottieView.setup(animation: featureModel.animation)
        titleLabel.text = featureModel.title
        descriptionView.text = featureModel.body
        lottieView.play()

        descriptionView.isUserInteractionEnabled = false
    }
}
