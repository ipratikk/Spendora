//
//  ActionButton.swift
//

import SwiftUI

public struct ActionButton: View {
    let icon: String
    let title: String
    var isDestructive: Bool
    let action: () -> Void
    
    public init(icon: String, title: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.isDestructive = isDestructive
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 17))
                
                Text(title)
                    .font(.system(size: 17, weight: .regular))
            }
            .foregroundColor(isDestructive ? .red : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.secondaryBackground)
            .cornerRadius(10)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            ActionButton(icon: "⭐", title: "Rate App", action: {})
            ActionButton(icon: "💬", title: "Contact Us", action: {})
            ActionButton(icon: "🚪", title: "Log Out", isDestructive: true, action: {})
        }
        .padding()
        .background(Color.primaryBackground)
        .preferredColorScheme(.dark)
    }
}
#endif
