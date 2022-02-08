//
//  Library.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import Foundation

class Library {

    let quotes: [Category: [String]]
    var bookmarks: Set<Bookmark> = [] {
        didSet {
            UserDefaults.standard.bookmarks = self.bookmarks
        }
    }

    init () {
        self.quotes = Category.allCases
            .map { ($0, Bundle.main.quotes(in: $0)) }
            .filter { !$0.1.isEmpty }
            .reduce(into: [:]) { $0[$1.0] = $1.1 }

        // Reload the quote's message in the bookmarks to prevent having entries in the wrong language
        // in the bookmark view
        self.bookmarks = Set(UserDefaults.standard.bookmarks.map {
            switch $0 {
            case .category:
                return $0
            case .quote(quote: let quote):
                if let translated = self.quote(at: quote.index, in: quote.category) {
                    return .quote(quote: translated)
                } else {
                    return $0
                }
            }
        })
    }

    func quote (at index: Int, in category: Category) -> Quote? {
        if let quotes = self.quotes[category], index >= 0, index < quotes.count {
            return Quote(index: index, category: category, message: quotes[index])
        }
        return nil
    }

    func quote (after quote: Quote) -> Quote? {
        if let result = self.quote(at: quote.index + 1, in: quote.category) {
            return result
        }
        if let category = quote.category.next, let result = self.first(in: category) {
            return result
        }
        return nil
    }

    func quote (before quote: Quote) -> Quote? {
        if let result = self.quote(at: quote.index - 1, in: quote.category) {
            return result
        }
        if let category = quote.category.previous, let result = self.last(in: category) {
            return result
        }
        return nil
    }

    func first (in category: Category) -> Quote? {
        return self.quote(at: 0, in: category)
    }

    func last (in category: Category) -> Quote? {
        if let count = self.quotes[category]?.count, let result = self.quote(at: count - 1, in: category) {
            return result
        }
        return nil
    }

    func hasBookmark(for quote: Quote) -> Bool {
        return self.bookmarks.contains(.quote(quote: quote))
    }

    func toggleBookmark(for quote: Quote) {
        if self.bookmarks.contains(.quote(quote: quote)) {
            self.bookmarks.remove(.quote(quote: quote))
        } else {
            self.bookmarks.insert(.quote(quote: quote))
        }
    }

    func removeBookmark(_ bookmark: Bookmark) {
        self.bookmarks.remove(bookmark)
    }

    func bookmarks(in category: Category) -> [Bookmark] {
        return self.bookmarks.filter {
            switch $0 {
            case .quote(quote: let quote):
                return quote.category == category
            default:
                return false
            }
        }.sorted(by: <)
    }
}
