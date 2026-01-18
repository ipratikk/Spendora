//
//  SplashLogoView.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 30/08/25.
//

import DotLottie
import SwiftUI
import SharedModels

struct SplashLogoView: View {
    var namespace: Namespace.ID
    @State private var drawNotebook = false

    var body: some View {
        DotLottieAnimation(fileName: "splash_icon", config: .init(autoplay: true, loop: false)).view()
            .frame(width: 150, height: 150)
            .matchedGeometryEffect(id: "appLogo", in: namespace)
    }
}


#Preview("Light Mode") {
    SplashLogoView(namespace: Namespace().wrappedValue)
        .preferredColorScheme(.light)
        .padding()
}

#Preview("Dark Mode") {
    SplashLogoView(namespace: Namespace().wrappedValue)
        .preferredColorScheme(.dark)
        .padding()
}
