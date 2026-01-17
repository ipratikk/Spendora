//
//  BannerView.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 17/09/25.
//

import SwiftUI

public struct BannerView: View {
    @ObservedObject var manager = BannerManager.shared
    
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer()
            if let message = manager.message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.9))
                    .cornerRadius(12)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .shadow(radius: 4)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: manager.message)
        .zIndex(1)
    }
}
