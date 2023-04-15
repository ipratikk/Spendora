//
//  FeaturesBuilder.swift
//  Onboarding
//
//  Created by Goel, Pratik | RIEPL on 14/04/23.
//

import Foundation
import UIKit
import Utilities

public class FeaturesBuilder {
    public static func build() -> UIViewController {
        return FeaturesViewController.initFromNib()
    }
}
