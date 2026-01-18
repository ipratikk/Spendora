//
//  ToggleRow.swift
//

import SwiftUI

public struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    let isLast: Bool
    
    public init(title: String, isOn: Binding<Bool>, isLast: Bool) {
        self.title = title
        self._isOn = isOn
        self.isLast = isLast
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.secondaryBackground)
        .overlay(alignment: .bottom) {
            if !isLast {
                Divider()
                    .background(Color.separator)
                    .padding(.leading, 20)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ToggleRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ToggleRow(title: "Push Notifications", isOn: .constant(true), isLast: false)
            ToggleRow(title: "Email Notifications", isOn: .constant(false), isLast: true)
        }
        .background(Color.secondaryBackground)
        .cornerRadius(10)
        .padding()
        .background(Color.primaryBackground)
        .preferredColorScheme(.dark)
    }
}
#endif
