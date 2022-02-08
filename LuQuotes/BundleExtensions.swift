//
//  BundleExtensions.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import Foundation

extension Bundle {
    func quotes(in category: Category) -> [String] {
        guard let url = self.url(forResource: "Quotes.\(String(describing: category))", withExtension: "txt") else {
            return []
        }

        return ((try? String(contentsOf: url)) ?? "")
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces)}
            .filter { !$0.isEmpty }
    }
}
