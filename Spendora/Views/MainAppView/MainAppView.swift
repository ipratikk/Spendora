import LoginFeature
import SwiftUI
import SharedModels
import SwiftData

@MainActor
public struct MainAppView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    public var body: some View {
        TabView {
            // MARK: - Spends Tab
            NavigationStack {
                SpendDashboardView()
            }
            .tabItem { Label("Spends", systemImage: "creditcard") }
            
            // MARK: - Account Tab
            NavigationStack {
                AccountView()
                    .environmentObject(loginViewModel)
            }
            .tabItem { Label("Account", systemImage: "note.text") }
        }
        .tint(.primary)
    }

}
