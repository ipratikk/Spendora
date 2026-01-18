//
//  AccountView.swift
//

import SwiftUI
import SharedModels
import LoginFeature

@MainActor
struct AccountView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    // MARK: - App Settings
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isFaceIDEnabled") private var isFaceIDEnabled = false
    
    // MARK: - State
    @State private var faceIDToggle = false
    @State private var faceIDErrorMessage: String?
    @State private var showingContactUs = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        profileSection
                        preferencesSection
                        actionButtons
                        footer
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingContactUs) {
                ContactUsView()
            }
        }
        .onAppear {
            faceIDToggle = isFaceIDEnabled
        }
    }
    
    // MARK: - Profile Section
    
    private var profileSection: some View {
        NavigationLink(destination: EditProfileView()) {
            ProfileSection(
                userName: getUserName(),
                userEmail: getUserEmail()
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Preferences Section
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PREFERENCES")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .padding(.leading, 20)
            
            VStack(spacing: 0) {
                NavigationLink(destination: NotificationsView()) {
                    PreferenceRow(
                        icon: "🔔",
                        title: "Notifications",
                        showBadge: true,
                        isLast: false
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: securityView) {
                    PreferenceRow(
                        icon: "🔒",
                        title: "Security",
                        showBadge: false,
                        isLast: false
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: PersonalizationView(isDarkMode: $isDarkMode)) {
                    PreferenceRow(
                        icon: "🎨",
                        title: "Personalization",
                        showBadge: false,
                        isLast: true
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .background(Color.secondaryBackground)
            .cornerRadius(10)
        }
    }
    
    private var securityView: some View {
        SecurityView(
            isDarkMode: $isDarkMode,
            isFaceIDEnabled: $isFaceIDEnabled,
            faceIDToggle: $faceIDToggle,
            faceIDErrorMessage: $faceIDErrorMessage
        )
        .environmentObject(loginViewModel)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 10) {
            ActionButton(icon: "⭐", title: "Rate App", action: rateApp)
            ActionButton(icon: "💬", title: "Contact Us", action: { showingContactUs = true })
            ActionButton(icon: "🚪", title: "Log Out", isDestructive: true, action: logout)
        }
    }
    
    // MARK: - Footer
    
    private var footer: some View {
        Text("Version 2.4.1 • Made with care")
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.secondary)
            .padding(.top, 12)
            .padding(.bottom, 32)
    }
    
    // MARK: - Helper Functions
    
    private func getUserName() -> String {
        // TODO: Replace with actual user data from loginViewModel
        // loginViewModel.currentUser?.name ?? "User"
        "Alex Smith"
    }
    
    private func getUserEmail() -> String {
        // TODO: Replace with actual user data from loginViewModel
        // loginViewModel.currentUser?.email ?? "user@email.com"
        "alex.smith@email.com"
    }
    
    private func rateApp() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID?action=write-review"),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    private func logout() {
        loginViewModel.logout()
        isDarkMode = false
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
    }
}

// MARK: - Preview

#if DEBUG
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(LoginViewModel())
            .preferredColorScheme(.dark)
    }
}
#endif
