//
//  LoginManaging.swift
//  MannKiBaat
//
//  Created by Pratik Goel on 30/08/25.
//

import Foundation

public protocol LoginManaging {
    func saveUserID(_ id: String)
    func getUserID() -> String?
    func removeUserID()
}
