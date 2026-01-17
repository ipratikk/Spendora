//
//  SplashScreenView.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 30/08/25.
//

import SwiftUI
import SharedModels

struct SplashScreenView: View {
    var namespace: Namespace.ID

    @State private var drawNotebook = false

    var body: some View {
        VStack {
//            NotebookShape()
//                .trim(from: 0, to: drawNotebook ? 1 : 0)
//                .stroke(Color.primary, lineWidth: 3)
//                .frame(width: 120, height: 120)
//                .matchedGeometryEffect(id: "notebook", in: namespace) // 👈 important
            
            Text("MannKiBaat")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                drawNotebook = true
            }
        }
    }
}


#Preview("Light Mode") {
    NavigationStack {
        SplashScreenView(namespace: Namespace().wrappedValue)
            .preferredColorScheme(.light)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        SplashScreenView(namespace: Namespace().wrappedValue)
            .preferredColorScheme(.dark)
    }
}
