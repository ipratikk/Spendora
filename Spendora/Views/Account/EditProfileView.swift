//
//  EditProfileView.swift
//

import SwiftUI
import SharedModels

struct EditProfileView: View {
    @State private var name = "Alex Smith"
    @State private var email = "alex.smith@email.com"
    @State private var bio = ""
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            ScrollView {
                VStack(spacing: 20) {
                    profileImageSection
                    formFields
                }
                .padding(20)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveProfile()
                }
                .fontWeight(.semibold)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var profileImageSection: some View {
        VStack(spacing: 12) {
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
                    .frame(width: 100, height: 100)
                
                Text("AS")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Button("Change Photo") {
                // TODO: Implement photo picker
            }
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.blue)
        }
        .padding(.vertical, 20)
    }
    
    private var formFields: some View {
        VStack(spacing: 0) {
            FormTextField(title: "Name", text: $name, isLast: false)
            FormTextField(title: "Email", text: $email, isLast: false)
            FormTextField(title: "Bio", text: $bio, isLast: true, isMultiline: true)
        }
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }
    
    // MARK: - Actions
    
    private func saveProfile() {
        // TODO: Implement save logic
        // Navigation will automatically go back on save
    }
}

// MARK: - Form Text Field Component

struct FormTextField: View {
    let title: String
    @Binding var text: String
    let isLast: Bool
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: isMultiline ? .top : .center) {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                    .frame(width: 80, alignment: .leading)
                
                if isMultiline {
                    TextEditor(text: $text)
                        .frame(height: 80)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                } else {
                    TextField("", text: $text)
                        .multilineTextAlignment(.trailing)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            if !isLast {
                Divider()
                    .background(Color.separator)
                    .padding(.leading, 100)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditProfileView()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
