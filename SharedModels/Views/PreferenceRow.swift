//
//  PreferenceRow.swift
//

import SwiftUI

public struct PreferenceRow: View {
    let icon: String
    let title: String
    let showBadge: Bool
    let isLast: Bool
    
    public init(icon: String, title: String, showBadge: Bool, isLast: Bool) {
        self.icon = icon
        self.title = title
        self.showBadge = showBadge
        self.isLast = isLast
    }
    
    public var body: some View {
        HStack {
            iconAndTitle
            Spacer()
            trailing
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.secondaryBackground)
        .overlay(alignment: .bottom) {
            if !isLast {
                Divider()
                    .background(Color.separator)
                    .padding(.leading, 60)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var iconAndTitle: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 20))
                .frame(width: 28)
            
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
        }
    }
    
    private var trailing: some View {
        HStack(spacing: 8) {
            if showBadge {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.6))
        }
    }
}

// MARK: - Preview

#if DEBUG
struct PreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            PreferenceRow(
                icon: "🔔",
                title: "Notifications",
                showBadge: true,
                isLast: false
            )
            
            PreferenceRow(
                icon: "🔒",
                title: "Security",
                showBadge: false,
                isLast: false
            )
            
            PreferenceRow(
                icon: "🎨",
                title: "Personalization",
                showBadge: false,
                isLast: true
            )
        }
        .background(Color.secondaryBackground)
        .cornerRadius(10)
        .padding()
        .background(Color.primaryBackground)
        .preferredColorScheme(.dark)
    }
}
#endif
