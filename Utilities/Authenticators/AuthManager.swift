//
//  AuthManager.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 29/04/23.
//

import Foundation
import FirebaseAuth

public class AuthManager {
    public static let shared = AuthManager()

    private let auth = Auth.auth()

    private var verificationID: String?

    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let verificationID = verificationID, error == nil else {
                print("Error during registration with phone number: \(error)")
                completion(false)
                return
            }
            self?.verificationID = verificationID
            completion(true)
        }
    }

    public func verify(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = self.verificationID else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )

        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }

    public func isLoggedIn(completion: @escaping (Bool) -> Void) {
        guard auth.currentUser != nil else {
            completion(false)
            return
        }
        completion(true)
    }
}
