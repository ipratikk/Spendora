//
//  LoginView.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 30/08/25.
//

import SwiftUI
import SharedModels
import AuthenticationServices

public struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    var namespace: Namespace.ID
    @Binding var showContent: Bool

    public init(viewModel: LoginViewModel, namespace: Namespace.ID, showContent: Binding<Bool>) {
        self.viewModel = viewModel
        self.namespace = namespace
        self._showContent = showContent
    }

    public var body: some View {
        VStack {
            Spacer()
            
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .matchedGeometryEffect(id: "appLogo", in: namespace)
            
            Text("Spendora")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()

            if showContent {
                VStack(spacing: 16) {
                    Text("Manage your expenses and more!")
                        .foregroundStyle(.secondary)
                }
                .transition(.opacity)
                .padding(.top, 24)
            }

            if showContent {
                SignInWithAppleButton(
                    .continue,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        viewModel.handleAppleLogin(result: result)
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom, 32)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding()
    }
}
