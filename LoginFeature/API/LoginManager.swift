//
//  LoginManaging.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 30/08/25.
//


import Foundation

public final class LoginManager: LoginManaging {
    public static let shared = LoginManager()
    private init() {}

    public func saveUserID(_ id: String) {
        KeychainManager.shared.saveAppleUserID(id)
    }

    public func getUserID() -> String? {
        KeychainManager.shared.getAppleUserID()
    }

    public func removeUserID() {
        KeychainManager.shared.removeAppleUserID()
    }
}
