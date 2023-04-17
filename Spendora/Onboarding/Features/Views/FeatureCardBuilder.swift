//
//  FeatureCardBuilder.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 17/04/23.
//

import Foundation
import UIKit
import Utilities

public class FeatureCardBuilder {
    public static func build(feature: Feature) -> UIView {
        return {
            let view = FeatureCardView.loadFromNib()
            view.setup(feature.model)
            return view
        }()
    }
}
