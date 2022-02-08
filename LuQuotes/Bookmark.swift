//
//  Bookmark.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import Foundation

enum Bookmark: Hashable, Codable, Equatable, Comparable {
    case category(category: Category)
    case quote(category: Category, index: Int)

    static func < (lhs: Bookmark, rhs: Bookmark) -> Bool {
        switch (lhs, rhs) {
        case (.category(category: let lCategory), .category(category: let rCategory)):
            return lCategory < rCategory

        case (.quote(category: let lCategory, index: let lIndex), .quote(category: let rCategory, index: let rIndex)):
            if lCategory != rCategory {
                return lCategory < rCategory
            }
            return lIndex < rIndex

        case (.category, .quote):
            return true

        default:
            return false
        }
    }
}
