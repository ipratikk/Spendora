//
//  AccountButtonTableViewCell.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 17/05/23.
//

import UIKit

class AccountButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with model: AccountItemModel) {
        button.layer.cornerRadius = button.frame.height / 2
        switch model.itemType {
            case .signout, .delete:
                button.setTitle(model.itemType.rawValue, for: .normal)
                button.setImage(model.itemType.icon, for: .normal)
                button.setTitleColor(model.itemType.titleColor, for: .normal)
                button.tintColor = model.itemType.titleColor
                button.backgroundColor = model.itemType.background
                button.addDefaultShadow()
                button.addBorder(color: model.itemType.borderColor, width: 1.0)
            default:
                break
        }
    }
}
