//
//  NotificationsView.swift
//

import SwiftUI
import SharedModels

struct NotificationsView: View {
    @AppStorage("pushNotificationsEnabled") private var pushNotificationsEnabled = true
    @AppStorage("emailNotificationsEnabled") private var emailNotificationsEnabled = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        ToggleRow(
                            title: "Push Notifications",
                            isOn: $pushNotificationsEnabled,
                            isLast: false
                        )
                        
                        ToggleRow(
                            title: "Email Notifications",
                            isOn: $emailNotificationsEnabled,
                            isLast: true
                        )
                    }
                    .background(Color.secondaryBackground)
                    .cornerRadius(10)
                }
                .padding(20)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#if DEBUG
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NotificationsView()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
