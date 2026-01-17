//
//  SettingsView.swift
//

import SwiftUI
import SharedModels
import LocalAuthentication
import LoginFeature

@MainActor
struct SettingsView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    // MARK: - App Settings
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isFaceIDEnabled") private var isFaceIDEnabled: Bool = false
    
    // Face ID local state
    @State private var faceIDToggle: Bool = false
    @State private var faceIDErrorMessage: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView()
                
                VStack(spacing: 24) {
                    // Logo
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.primary)
                    
                    Text("Make it your own")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // MARK: - Dark Mode
                    HStack {
                        Text("Dark Mode")
                            .font(.headline)
                        Spacer()
                        Toggle(isOn: $isDarkMode) {}
                            .labelsHidden()
                            .onChange(of: isDarkMode) { newValue in
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                            }
                    }
                    .padding()
                    .background(Color.secondaryBackground.opacity(0.2))
                    .cornerRadius(12)
                    
                    // MARK: - Face ID
                    HStack {
                        Text("Face ID Login")
                            .font(.headline)
                        Spacer()
                        Toggle(isOn: $faceIDToggle) {}
                            .labelsHidden()
                            .onChange(of: faceIDToggle) { enabled in
                                if enabled {
                                    loginViewModel.authenticateFaceID { success, error in
                                        if success {
                                            isFaceIDEnabled = true
                                            faceIDErrorMessage = nil
                                        } else {
                                            faceIDToggle = false
                                            faceIDErrorMessage = error
                                        }
                                    }
                                } else {
                                    isFaceIDEnabled = false
                                    loginViewModel.faceIDAuthenticated = false
                                    loginViewModel.faceIDErrorMessage = nil
                                    faceIDErrorMessage = nil
                                }
                            }
                    }
                    .padding()
                    .background(Color.secondaryBackground.opacity(0.2))
                    .cornerRadius(12)
                    
                    // Face ID error
                    if let error = faceIDErrorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    // MARK: - Logout Button
                    Button(role: .destructive) {
                        loginViewModel.logout()
                        // Reset Dark Mode to system style on logout
                        isDarkMode = false
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
                    } label: {
                        Text("Logout")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            // Initialize Face ID toggle with saved value
            faceIDToggle = isFaceIDEnabled
        }
    }
}
