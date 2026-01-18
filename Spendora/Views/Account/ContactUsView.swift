//
//  ContactUsView.swift
//

import SwiftUI
import MessageUI
import SharedModels

struct ContactUsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingMailComposer = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    icon
                    content
                    actionButtons
                    
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Contact Us")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingMailComposer) {
                if MFMailComposeViewController.canSendMail() {
                    MailComposeView(
                        recipients: ["support@example.com"],
                        subject: "App Support Request"
                    )
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var icon: some View {
        Text("💬")
            .font(.system(size: 60))
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            Text("Get in Touch")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            
            Text("We'd love to hear from you! Whether you have questions, feedback, or need support, feel free to reach out.")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            ContactButton(
                icon: "envelope.fill",
                title: "Email Us",
                subtitle: "support@example.com",
                action: sendEmail
            )
            
            ContactButton(
                icon: "link",
                title: "Visit Website",
                subtitle: "www.example.com",
                action: openWebsite
            )
        }
    }
    
    // MARK: - Actions
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            showingMailComposer = true
        } else {
            // Fallback to mailto URL
            if let url = URL(string: "mailto:support@example.com") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func openWebsite() {
        if let url = URL(string: "https://www.example.com") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Contact Button Component

struct ContactButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            .padding(16)
            .background(Color.secondaryBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Mail Compose View

struct MailComposeView: UIViewControllerRepresentable {
    let recipients: [String]
    let subject: String
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            parent.dismiss()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
            .preferredColorScheme(.dark)
    }
}
#endif
