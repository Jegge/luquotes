//
//  UserDefaultExtensions.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import Foundation
import UIKit

extension UserDefaults {
    func set<T>(encodable object: T, forKey key: String) where T: Encodable {
        if let data = try? JSONEncoder().encode(object) {
            set(data, forKey: key)
        }
    }

    func decodable<T>(forKey key: String) -> T? where T: Decodable {
        if let data = data(forKey: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
}

extension UserDefaults {
    private struct UserDefault {
        static let currentCategory = "CurrentCategory"
        static let currentIndex = "CurrentIndex"
        static let bookmarks = "Bookmarks"
        static let forumUrl = "forumUrl"
    }

    func register () {
        self.register(defaults: [
            UserDefault.currentCategory: Category.introduction.rawValue,
            UserDefault.currentIndex: 0,
            UserDefault.bookmarks: Data(),
            UserDefault.forumUrl: URL(string: "https://www.liberationunleashed.com/nation/")!
        ])
    }

    var currentCategory: Category {
        get {
            return Category(rawValue: self.integer(forKey: UserDefault.currentCategory)) ?? .introduction
        }
        set {
            self.set(newValue.rawValue, forKey: UserDefault.currentCategory)
        }
    }

    var currentIndex: Int {
        get {
            return self.integer(forKey: UserDefault.currentIndex)
        }
        set {
            self.set(newValue, forKey: UserDefault.currentIndex)
        }
    }

    var bookmarks: Set<Bookmark> {
        get {
            return self.decodable(forKey: UserDefault.bookmarks) ?? []
        }
        set {
            self.set(encodable: newValue, forKey: UserDefault.bookmarks)
        }
    }

    var forumUrl: URL {
        return self.url(forKey: UserDefault.forumUrl)!
    }
}
