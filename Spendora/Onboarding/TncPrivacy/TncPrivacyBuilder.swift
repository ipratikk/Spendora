//
//  TncPrivacyBuilder.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 15/04/23.
//

import Foundation
import UIKit
import Utilities

public class TncPrivacyBuilder {
    public static func build(type: TncType) -> UIViewController {
        return {
            let view = TncPrivacyViewController.initFromNib()
            view.setup(type: type)
            return view
        }()
    }
}
