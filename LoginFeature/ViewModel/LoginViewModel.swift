//
//  LoginViewModel.swift
//  MannKiBaat
//

import Foundation
import SwiftUI
import AuthenticationServices
import Combine
import LocalAuthentication

@MainActor
public class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var isLoggedIn: Bool = false
    @Published public var errorMessage: String?
    
    // Face ID state
    @Published public var faceIDAuthenticated: Bool = false
    @Published public var faceIDErrorMessage: String?
    
    // MARK: - Dependencies
    private let loginManager: LoginManaging
    
    // MARK: - Initializer
    public init(loginManager: LoginManaging = LoginManager.shared) {
        self.loginManager = loginManager
        self.isLoggedIn = loginManager.getUserID() != nil
    }
    
    // MARK: - Apple Login
    public func handleAppleLogin(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                loginManager.saveUserID(credential.user)
                isLoggedIn = true
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    public func checkLogin() {
        isLoggedIn = loginManager.getUserID() != nil
    }
    
    // MARK: - Logout
    public func logout() {
        loginManager.removeUserID()
        isLoggedIn = false
        faceIDAuthenticated = false
        faceIDErrorMessage = nil
    }
    
    // MARK: - Face ID Authentication
    public func authenticateFaceID(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, "Face ID not available on this device.")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Authenticate to access your notes") { success, authError in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if success {
                    self.faceIDAuthenticated = true
                    self.faceIDErrorMessage = nil
                    completion(true, nil)
                } else {
                    self.faceIDAuthenticated = false
                    let msg = authError?.localizedDescription ?? "Failed to authenticate with Face ID."
                    self.faceIDErrorMessage = msg
                    completion(false, msg)
                }
            }
        }
    }

}
