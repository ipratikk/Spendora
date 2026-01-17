//
//  BannerManager.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 17/09/25.
//

import SwiftUI
public import Combine

@MainActor
public final class BannerManager: ObservableObject {
    public static let shared = BannerManager()
    private init() {}
    
    @Published public var message: String? = nil
    
    public func show(message: String) {
        self.message = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.message = nil
        }
    }
}
