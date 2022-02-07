//
//  Category.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import UIKit

enum Category: Int, LocalizedStringConvertible, CaseIterable, Codable, Equatable, Hashable, Comparable {

    case introduction
    case expectations
    case fear
    case directExperience
    case labelingAndLanguage
    case story
    case exercises
    case looking
    case gate
    case afterGate


    var color: UIColor {
        return UIColor(named: "\(String(describing: self))Color") ?? .black
    }

    var next: Category? {
        return Category(rawValue: self.rawValue + 1)
    }

    var previous: Category? {
        return Category(rawValue: self.rawValue - 1)
    }

    static func < (lhs: Category, rhs: Category) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

}
