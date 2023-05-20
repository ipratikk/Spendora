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
    @IBOutlet weak var changeImageButton: UIButton!
//    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var cutoutView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        displayImage.contentMode = .center
        displayImage.layer.borderWidth = 0.5
        displayImage.layer.borderColor = UIColor.gray.cgColor
        displayImage.layer.cornerRadius = displayImage.frame.height / 2
        cutoutView.layer.cornerRadius = 30
        cutoutView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        changeImageButton.layer.cornerRadius = changeImageButton.bounds.height / 2
        changeImageButton.contentMode = .scaleAspectFill
        changeImageButton.clipsToBounds = true
//        backgroundImageView.isUserInteractionEnabled = false
    }

    func setup(with model: AccountItemModel) {
        guard let imageURL = model.user.photoURLString else {
            displayImage.image = UIImage(systemName: "camera.fill")
            return
        }
        displayImage.sd_setImage(with: imageURL)
    }
}
