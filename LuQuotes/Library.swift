//
//  Library.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

class Library {
    private let quotes: [Category: [String]]
    private var bookmarks: Set<Bookmark> = [] {
        didSet {
            UserDefaults.standard.bookmarks = self.bookmarks
        }
    }

    init () {
        self.quotes = Category.allCases
            .map { ($0, Bundle.main.quotes(in: $0)) }
            .filter { !$0.1.isEmpty }
            .reduce(into: [:]) { $0[$1.0] = $1.1 }

        self.bookmarks = UserDefaults.standard.bookmarks

        self.indexQuotes()
    }

    private func indexQuotes () {
        let searchableItems = self.quotes.keys
            .flatMap { category in self.quotes[category]!.enumerated().map { (category, $0.offset, (try? $0.element.strippedHtmlTags()) ?? "") } }
            .map { (category: Category, index: Int, message: String) -> CSSearchableItem in

                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
                attributeSet.title = message
                attributeSet.containerIdentifier = "\(category.rawValue)"
                attributeSet.containerOrder = category.rawValue as NSNumber
                attributeSet.containerDisplayName =  category.localizedDescription
                attributeSet.contentDescription = message
                attributeSet.keywords = [ "lu", "quotes", "liberation", "unleashed", Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String ?? "Quotes"]
                return CSSearchableItem(uniqueIdentifier: "\(category.rawValue)-\(index)",
                                            domainIdentifier: "com.realvirtuality.LuQuotes",
                                            attributeSet: attributeSet)
            }

        CSSearchableIndex().indexSearchableItems(searchableItems, completionHandler: nil)
    }

    func quote (at bookmark: Bookmark) -> Quote? {
        switch bookmark {
        case .category(let category):
            return self.firstQuote(in: category)
        case .quote(let category, let index):
            return self.quote(at: index, in: category)
        }
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
        if let category = quote.category.next, let result = self.firstQuote(in: category) {
            return result
        }
        return nil
    }

    func quote (before quote: Quote) -> Quote? {
        if let result = self.quote(at: quote.index - 1, in: quote.category) {
            return result
        }
        if let category = quote.category.previous, let result = self.lastQuote(in: category) {
            return result
        }
        return nil
    }

    func firstQuote (in category: Category) -> Quote? {
        return self.quote(at: 0, in: category)
    }

    func lastQuote (in category: Category) -> Quote? {
        if let count = self.quotes[category]?.count, let result = self.quote(at: count - 1, in: category) {
            return result
        }
        return nil
    }

    func bookmarks (in targetCategory: Category) -> [Bookmark] {
        return [.category(category: targetCategory)] + self.bookmarks.filter {
            switch $0 {
            case .category(category: let category):
                return targetCategory == category
            case .quote(category: let category, index: _):
                return targetCategory == category
            }
        }
    }

    func contains (bookmark: Bookmark) -> Bool {
        return self.bookmarks.contains(bookmark)
    }

    func toggle (bookmark: Bookmark) {
        if self.bookmarks.contains(bookmark) {
            self.bookmarks.remove(bookmark)
        } else {
            self.bookmarks.insert(bookmark)
        }
    }

    func remove (bookmark: Bookmark) {
        self.bookmarks.remove(bookmark)
    }
}
