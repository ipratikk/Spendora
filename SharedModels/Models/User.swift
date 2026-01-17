//
//  User.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 30/08/25.
//


import Foundation

public struct User {
    public let id: UUID
    public let name: String

    public init(id: UUID = .init(), name: String) {
        self.id = id
        self.name = name
    }
}
