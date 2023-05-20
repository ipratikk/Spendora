//
//  File.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 12/05/23.
//

import Foundation
import UIKit
import Utilities

public enum AccountItemType: String {
    case name = "Name"
    case email = "Email"
    case phone = "Phone"
    case signout = "Sign out"
    case delete = "Delete account"
    case image = "Profile Picture"

    var icon: UIImage? {
        switch self {
            case .name:
                return UIImage(systemName: "person.fill")
            case .email:
                return UIImage(systemName: "mail.fill")
            case .signout:
                return UIImage(systemName: "escape")
            case .delete:
                return UIImage(systemName: "trash")
            default:
                return nil
        }
    }

    var background: UIColor {
        switch self {
            case .signout:
                return .white
            case .delete:
                return .red
            default:
                return .clear
        }
    }

    var titleColor: UIColor {
        switch self {
            case .signout:
                return .red
            case .delete:
                return .white
            default:
                return .label
        }
    }

    var borderColor: UIColor {
        switch self {
            case .signout:
                return .red
            default:
                return .clear
        }
    }
}

public struct AccountItemModel {
    let user: FirebaseUser
    let itemType: AccountItemType

    init(user: FirebaseUser, itemType: AccountItemType) {
        self.user = user
        self.itemType = itemType
    }
}
