//
//  UserModel.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 11/05/23.
//

import Foundation
import FirebaseAuth

public struct FirebaseUser {
    let uid: String
    let email: String?
    let phoneNumber: String?
    let displayName: String?
    let photoURL: URL?

    public init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
        self.phoneNumber = user.phoneNumber
        self.displayName = user.displayName
        self.photoURL = user.photoURL
    }

    public var isProfileComplete: Bool {
        guard let phoneNumber = phoneNumber, phoneNumber.count > 0 else { return false }
        guard let displayName = displayName, displayName.count > 0 else { return false }
        return true
    }

    public var uidString: String {
        return uid
    }

    public var emailString: String? {
        return email
    }

    public var phoneNumberString: String? {
        return phoneNumber
    }

    public var displayNameString: String? {
        return displayName
    }

    public var photoURLString: URL? {
        return photoURL
    }
}
