//
//  NSAttributedStringExtensions.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 11.02.22.
//

import UIKit

extension NSAttributedString {

    convenience init? (html: String) {
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        guard
            let data = html.data(using: .utf16, allowLossyConversion: true),
            let text = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
        else {
            return nil
        }
        self.init(attributedString: text)
    }

    /// Returns a new `NSAttributedString` with a changed font face, but the same traits (bold, italic) and size
    func setting (font: UIFont) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length), options: .longestEffectiveRangeNotRequired) { attribute, range, _ in
            if let descriptor = (attribute as? UIFont)?.fontDescriptor {
                let newFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(descriptor.symbolicTraits)!, size: 0)
                result.addAttribute(.font, value: newFont, range: range)
            }
        }
        return result
    }

    /// Returns a new `NSAttributedString` with an increased font size, but the same traits (bold, italic) and font face
    func increasingFontSize (by pointSize: CGFloat) -> NSAttributedString {
        if pointSize < .ulpOfOne {
            return self
        }

        let result = NSMutableAttributedString(attributedString: self)
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length), options: .longestEffectiveRangeNotRequired) { attribute, range, _ in
            if let font = (attribute as? UIFont) {
                let newFont = UIFont(descriptor: font.fontDescriptor, size: font.pointSize + pointSize)
                result.addAttribute(.font, value: newFont, range: range)
            }
        }
        return result
    }

    /// Returns a new `NSAttributedString` with a changed foreground and background color.
    func setting (textColor: UIColor, backgroundColor: UIColor) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .backgroundColor: backgroundColor
        ]
        result.addAttributes(attributes, range: NSRange(location: 0, length: result.length))
        return result
    }

    /// Returns a new `NSAttributedString`, but updates all paragraph styles to use a given hyphenation factor.
    func setting (hyphenationFactor: Float) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        self.enumerateAttribute(.paragraphStyle, in: NSRange(location: 0, length: self.length), options: .longestEffectiveRangeNotRequired) { attribute, range, _ in
            if let paragraph = (attribute as? NSParagraphStyle)?.mutableCopy() as? NSMutableParagraphStyle {
                paragraph.hyphenationFactor = hyphenationFactor
                result.addAttribute(.paragraphStyle, value: paragraph, range: range)
            }
        }
        return result
    }
}
