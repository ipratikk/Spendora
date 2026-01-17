//
//  NSAttributedString+Extension.swift
//  SharedModels
//
//  Created by Pratik Goel on 31/08/25.
//

import Foundation

// MARK: - Helper extensions
public extension NSAttributedString {
    func archive() -> Data {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        } catch {
            print("⚠️ Failed to archive attributed string: \(error)")
            return Data()
        }
    }
    
    static func unarchive(from data: Data) -> NSAttributedString {
        do {
            if let attributed = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSAttributedString {
                return attributed
            }
        } catch {
            print("⚠️ Failed to unarchive attributed string: \(error)")
        }
        return NSAttributedString(string: "")
    }
}
