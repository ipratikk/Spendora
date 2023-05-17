//
//  CountryModel.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 20/04/23.
//

import Foundation
public struct Country: Codable {
    public let name: String
    public let flag: String
    public let code: String
    public let dial_code: String
    public var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case name
        case flag
        case code
        case dial_code
    }

    public func getFlag() -> String {
        code
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}

struct CountryListModel
{
    var countries: [Country] = []

    mutating func getNameSortedDictionary() -> (sectionNamesArray: [String], dataSourceDictionary: [String: [Country]]) {
        let characterSortedDictionary = Dictionary(grouping: countries) { String($0.name.first!) }
        let characterSections = Array(characterSortedDictionary.keys).sorted{ $0 < $1 }
        return (characterSections, characterSortedDictionary)
    }
}
