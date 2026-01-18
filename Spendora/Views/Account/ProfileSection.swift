//
//  ProfileSection.swift
//

import SwiftUI
import SharedModels

struct ProfileSection: View {
    let userName: String
    let userEmail: String
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                profileImage
                profileInfo
            }
            .padding(.top, 32)
            .padding(.bottom, 20)
            
            Divider()
                .background(Color.separator)
            
            editIndicator
        }
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }
    
    // MARK: - Subviews
    
    private var profileImage: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.4, green: 0.494, blue: 0.918),  // #667eea
                            Color(red: 0.463, green: 0.294, blue: 0.635)  // #764ba2
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 90, height: 90)
            
            Text(initials)
                .font(.system(size: 36, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    private var profileInfo: some View {
        VStack(spacing: 2) {
            Text(userName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(userEmail)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
        }
    }
    
    private var editIndicator: some View {
        HStack {
            Text("Edit Profile")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.6))
                .padding(.trailing, 20)
        }
        .padding(.vertical, 14)
    }
    
    // MARK: - Computed Properties
    
    private var initials: String {
        let components = userName.components(separatedBy: " ")
        if components.count >= 2 {
            let firstInitial = components[0].prefix(1)
            let lastInitial = components[1].prefix(1)
            return "\(firstInitial)\(lastInitial)".uppercased()
        }
        return userName.prefix(2).uppercased()
    }
}

// MARK: - Preview

#if DEBUG
struct ProfileSection_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSection(
            userName: "Alex Smith",
            userEmail: "alex.smith@email.com"
        )
        .padding()
        .background(GradientBackgroundView())
        .preferredColorScheme(.dark)
    }
}
#endif
