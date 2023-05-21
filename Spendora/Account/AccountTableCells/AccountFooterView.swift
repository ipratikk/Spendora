//
//  AccountFooterView.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 20/05/23.
//

import UIKit
import Utilities

private let accountFooterView = "AccountFooterView"
class AccountFooterView: UIView, NibLoadable {
    private(set) static var nibName: String = accountFooterView

    @IBOutlet weak var footerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure() {
        backgroundColor = .primaryBackground
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        footerLabel.text = "App version: v\(appVersion)"
        footerLabel.textColor = .darkGray
    }
}
