//
//  Bookmark.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import Foundation

enum Bookmark: Hashable, Codable, Equatable, Comparable {
    case category(category: Category)
    case quote(quote: Quote)

    static func < (lhs: Bookmark, rhs: Bookmark) -> Bool {
        switch (lhs, rhs) {
        case (.category(category: let lCategory), .category(category: let rCategory)):
            return lCategory < rCategory

        case (.quote(quote: let lQuote), .quote(quote: let rQuote)):
            return lQuote < rQuote

        default:
            return true
        }
    }
}
