//
//  NoDataView.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 24/04/23.
//

import UIKit

private let noDataView = "NoDataView"
class NoDataView: UIView, NibLoadable {

    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var noDataTitle: UILabel!

    private(set) static var nibName: String = noDataView

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(image: UIImage?, title: String) {
        noDataImage.image = image ?? UIImage(systemName: "xmark.circle")
        noDataImage.tintColor = UIColor(hex: "#595958")
        noDataTitle.text = title
    }
}
