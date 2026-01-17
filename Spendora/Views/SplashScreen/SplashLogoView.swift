//
//  SplashLogoView.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 30/08/25.
//

import SwiftUI
import SharedModels

struct SplashLogoView: View {
    var namespace: Namespace.ID
    @State private var drawNotebook = false

    var body: some View {
//        NotebookShape()
//            .trim(from: 0, to: drawNotebook ? 1 : 0)
//            .stroke(Color.primary, lineWidth: 3)
//            .frame(width: 120, height: 120)
//            .matchedGeometryEffect(id: "notebook", in: namespace)
//            .onAppear {
//                withAnimation(.easeInOut(duration: 1.5)) {
//                    drawNotebook = true
//                }
//            }
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
