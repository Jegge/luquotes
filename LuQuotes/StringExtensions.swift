//
//  StringExtensions.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 11.02.22.
//

import Foundation

extension String {
    func strippedHtmlTags() throws -> String {
        let regex = try NSRegularExpression(pattern: "<.*?>", options: .caseInsensitive)
        var start = self.startIndex
        var result = ""

        for match in regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)) {
            if let range = Range(match.range, in: self) {
                result.append(contentsOf: self[start..<range.lowerBound])
                if self[range] == "<br>" {
                    result.append(contentsOf: "\n")
                }
                start = range.upperBound
            }
        }
        result.append(contentsOf: self[start..<self.endIndex])

        return result.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")
    }
}
