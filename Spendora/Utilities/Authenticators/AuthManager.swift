//
//  AuthManager.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 29/04/23.
//

import Foundation
import FirebaseAuth

public enum AuthError: Error {
    case unknownError
    case invalidVerificationID
    case otpError
    case notLoggedIn
}

public class AuthManager {
    public static let shared = AuthManager()

    private let auth = Auth.auth()

    private var verificationID: String?

    public func startAuth(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let verificationID = verificationID, error == nil else {
                completion(.failure(error ?? AuthError.unknownError))
                return
            }
            self?.verificationID = verificationID
            UserDefaults.standard.set(verificationID, forKey: Constants.UserdefaultKeys.verificationID.rawValue)
            completion(.success(true))
        }
    }

    public func verify(smsCode: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        guard let verificationID = self.verificationID else {
            completion(.failure(AuthError.invalidVerificationID))
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )

        auth.signIn(with: credential) { result, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let result = result else {
                completion(.failure(AuthError.otpError))
                return
            }

            let user = FirebaseUser(user: result.user)
            completion(.success(user))
        }
    }

    public func isLoggedIn(completion: @escaping (Result<FirebaseUser,Error>) -> Void) {
        guard let user = auth.currentUser else {
            completion(.failure(AuthError.notLoggedIn))
            return
        }
        completion(.success(FirebaseUser(user: user)))
    }

    public func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
}
