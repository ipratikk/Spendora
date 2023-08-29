//
//  AccountDetailsTableViewCell.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 12/05/23.
//

import UIKit
import Utilities
import RxSwift
import RxCocoa

class AccountDetailsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var detailLabel: UILabel!

    @IBOutlet weak var detailText: UITextField!

    @IBOutlet weak var detailPhoneStack: UIStackView!
    @IBOutlet weak var detailPhoneIcon: UIButton!
    @IBOutlet weak var detailPhoneText: PhoneTextField!

    @IBOutlet weak var detailEmailText: EmailTextField!

    private let disposeBag = DisposeBag()
    private var reuseDisposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        detailText.isHidden = true
        detailPhoneStack.isHidden = true
        detailEmailText.isHidden = true
        setupUI()
    }

    func setupUI() {
        backgroundColor = .primaryBackground
        [detailText, detailPhoneStack, detailEmailText]
            .forEach {
                $0?.addBorder(color: .lightGray.withAlphaComponent(0.7), width: 0.5)
                $0?.layer.cornerRadius = ($0?.frame.height ?? 0) / 2
            }
        detailPhoneIcon.addBorder(color: .gray.withAlphaComponent(0.7), width: 0.5)
        detailPhoneStack.clipsToBounds = true
        [detailText, detailPhoneText, detailEmailText]
            .forEach {
                $0?.font = UIFont.systemFont(ofSize: 17)
                addPaddingToTextField($0!)
            }
    }

    func configure(for user: AccountModel, with model: AccountItemModel) {
        detailLabel.text = model.itemType.rawValue
        print("Detail label text: \(model.itemType.rawValue)")
        switch model.itemType {
            case .name:
                detailText.isHidden = false
                detailText.text = user.name
                detailText.delegate = self
            case .phone:
                detailPhoneStack.isHidden = false
                detailPhoneText.text = user.phone
                detailPhoneText.delegate = self
            case .email:
                detailEmailText.isHidden = false
                detailEmailText.text = user.email
                detailEmailText.delegate = self
            default:
                break
        }
    }

    func addPaddingToTextField(_ textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
    }
}
