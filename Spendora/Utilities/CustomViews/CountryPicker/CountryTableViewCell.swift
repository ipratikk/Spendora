//
//  CountryTableViewCell.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 21/04/23.
//

import UIKit
import RxSwift

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryFlag: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    private var reuseDisposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag()
    }

    func setRowSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkImage.isHidden = !selected
    }

    func setup(country: Country) {
        let countryName = country.name
        let countryDialCode = country.dial_code
        let countryFlag = country.getFlag()
        let title = countryName + " (" + countryDialCode + ")"
        self.countryName.text = title
        self.countryFlag.text = countryFlag
        checkImage.image = UIImage(systemName: "checkmark.circle.fill")
        checkImage.isHidden = !country.isSelected
    }
}
