//
//  FaceIDErrorView.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 31/08/25.
//

import SwiftUI
import SharedModels

public struct FaceIDErrorView: View {
    let retryAction: () -> Void
    
    public init(retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "faceid")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.primary)
            
            Text("For Manasa's eyes only!")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button("Authenticate again") {
                retryAction()
            }
            .padding()
            .background(Color.buttonBackground)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
    }
}
