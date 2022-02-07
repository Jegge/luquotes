//
//  LocalizedStringConvertible.swift
//  FreeDoku
//
//  Created by Sebastian Boettcher on 24.01.22.
//

import Foundation

protocol LocalizedStringConvertible {
    var resourceKey: String { get }
    var resourceComment: String { get }
    var localizedDescription: String { get }
}

extension LocalizedStringConvertible {
    var resourceKey: String {
        return "\(String(describing: type(of: self)))_\(String(describing: self))"
    }
    var resourceComment: String {
        return "Localization for value '\(String(describing: self))' in enum '\(String(describing: type(of: self)))'"
    }
    var localizedDescription: String {
        return NSLocalizedString(resourceKey, comment: resourceComment)
    }
}
