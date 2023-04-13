//
//  LottieView.swift
//  Spendora
//
//  Created by Pratik Goel on 10/04/23.
//
import UIKit
import Lottie

class LottieView: LottieAnimationView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func setup(animation: LottieAnimation?, loopMode: LottieLoopMode = .loop, contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.animation = animation
        self.loopMode = loopMode
        self.contentMode = contentMode
    }
}
