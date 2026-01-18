//
//  PersonalizationView.swift
//

import SwiftUI
import SharedModels

struct PersonalizationView: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            ScrollView {
                VStack(spacing: 20) {
                    darkModeToggle
                }
                .padding(20)
            }
        }
        .navigationTitle("Personalization")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    
    private var darkModeToggle: some View {
        HStack {
            Text("Dark Mode")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isDarkMode)
                .labelsHidden()
                .onChange(of: isDarkMode) { newValue in
                    updateAppearance(newValue)
                }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }
    
    // MARK: - Actions
    
    private func updateAppearance(_ isDark: Bool) {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDark ? .dark : .light
    }
}

// MARK: - Preview

#if DEBUG
struct PersonalizationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PersonalizationView(isDarkMode: .constant(false))
        }
        .preferredColorScheme(.dark)
    }
}
#endif
