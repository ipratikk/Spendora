//
//  Builder.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 14/04/23.
//

import Foundation
import UIKit
import Utilities

public class OnboardingBuilder {
    public static func build() -> UIViewController {
        return OnboardingViewController.initFromNib()
    }
}
