//
//  Quote.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import Foundation

struct Quote: Hashable, Codable, Equatable {
    let index: Int
    let category: Category
    let message: String

    var bookmark: Bookmark {
        return .quote(category: self.category, index: self.index)
    }
}
