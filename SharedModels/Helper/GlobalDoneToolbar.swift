//
//  GlobalDoneToolbar.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 02/09/25.
//

import SwiftUI

struct GlobalDoneToolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                        to: nil, from: nil, for: nil)
                    }
                }
            }
    }
}
