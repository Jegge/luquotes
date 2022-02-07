//
//  Quote.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import Foundation

struct Quote: Hashable, Codable, Equatable, Comparable {
    let index: Int
    let category: Category
    let message: String

    static func < (lhs: Quote, rhs: Quote) -> Bool {
        if lhs.category != rhs.category {
            return lhs.category < rhs.category
        }
        if lhs.index != rhs.index {
            return lhs.index < rhs.index
        }
        return lhs.message < rhs.message
    }
}
