//
//  SecurityView.swift
//

import SwiftUI
import LoginFeature
import SharedModels

struct SecurityView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @Binding var isDarkMode: Bool
    @Binding var isFaceIDEnabled: Bool
    @Binding var faceIDToggle: Bool
    @Binding var faceIDErrorMessage: String?
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            ScrollView {
                VStack(spacing: 20) {
                    faceIDSection
                    
                    if let error = faceIDErrorMessage {
                        errorMessage(error)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Security")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    
    private var faceIDSection: some View {
        HStack {
            Text("Face ID Login")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $faceIDToggle)
                .labelsHidden()
                .onChange(of: faceIDToggle) { enabled in
                    handleFaceIDToggle(enabled)
                }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }
    
    private func errorMessage(_ error: String) -> some View {
        Text(error)
            .font(.system(size: 13))
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
    
    // MARK: - Actions
    
    private func handleFaceIDToggle(_ enabled: Bool) {
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

// MARK: - Preview

#if DEBUG
struct SecurityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SecurityView(
                isDarkMode: .constant(false),
                isFaceIDEnabled: .constant(false),
                faceIDToggle: .constant(false),
                faceIDErrorMessage: .constant(nil)
            )
            .environmentObject(LoginViewModel())
        }
        .preferredColorScheme(.dark)
    }
}
#endif
