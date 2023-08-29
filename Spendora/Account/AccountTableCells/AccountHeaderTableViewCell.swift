//
//  AccountHeaderTableViewCell.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 12/05/23.
//

import UIKit
import Utilities
import SDWebImage

class AccountHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var updateImage: UIButton!
    @IBOutlet weak var cutoutView: UIView!
    @IBOutlet weak var imageTap: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        displayImage.contentMode = .center
        displayImage.layer.borderWidth = 0.5
        displayImage.layer.borderColor = UIColor.gray.cgColor
        displayImage.layer.cornerRadius = displayImage.frame.height / 2
        cutoutView.layer.cornerRadius = 30
        cutoutView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        updateImage.layer.cornerRadius = updateImage.bounds.height / 2
        updateImage.contentMode = .scaleAspectFill
        updateImage.clipsToBounds = true
        updateImage.backgroundColor = .label
        let changeImage = UIImage(systemName: "pencil")?.withTintColor(.primaryButtonTitle, renderingMode: .alwaysOriginal)
        updateImage.setImage(changeImage, for: .normal)
    }

    func configure(for user: AccountModel, with model: AccountItemModel) {
        cutoutView.backgroundColor = .primaryBackground
        guard let imageURL = user.imageURL else {
            displayImage.image = UIImage(systemName: "camera.fill")
            return
        }
        displayImage.sd_setImage(with: imageURL)
    }
}
