//
//  AppEntryView.swift
//

import SwiftUI
import LoginFeature
import SharedModels
import LocalAuthentication

@MainActor
public struct AppEntryView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @Environment(\.modelContext) private var modelContext
    
    // Splash animation
    @State private var showSplash = true
    @Namespace private var logoNamespace
    @State private var showLoginContent = false
    
    // Face ID check
    @AppStorage("isFaceIDEnabled") private var isFaceIDEnabled: Bool = false
    @State private var showFaceIDErrorScreen = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            GradientBackgroundView()
            
            if showSplash {
                SplashLogoView(namespace: logoNamespace)
                    .transition(.opacity)
            } else {
                if loginViewModel.isLoggedIn {
                    // Face ID enabled and not authenticated
                    if isFaceIDEnabled && !loginViewModel.faceIDAuthenticated {
                        if showFaceIDErrorScreen {
                            FaceIDErrorView {
                                // Retry Face ID
                                authenticateFaceID()
                            }
                        } else {
                            Color.clear
                                .onAppear { authenticateFaceID() }
                        }
                    } else {
                        MainAppView()
                            .environmentObject(loginViewModel)
                            .transition(.opacity)
                    }
                } else {
                    LoginView(
                        viewModel: loginViewModel,
                        namespace: logoNamespace,
                        showContent: $showLoginContent
                    )
                    .transition(.opacity)
                }
            }
        }
        .onAppear { performSplashSequence() }
    }
    
    // MARK: - Helpers
    
    private func performSplashSequence() {
        loginViewModel.checkLogin()
        
        // Splash delay animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.6)) { showSplash = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeInOut(duration: 0.6)) { showLoginContent = true }
            }
        }
    }
    
    private func authenticateFaceID() {
        loginViewModel.authenticateFaceID { success, _ in
            showFaceIDErrorScreen = !success
        }
    }
}
