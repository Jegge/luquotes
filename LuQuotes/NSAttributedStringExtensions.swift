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

    func setting (textColor: UIColor, backgroundColor: UIColor) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .backgroundColor: backgroundColor
        ]
        result.addAttributes(attributes, range: NSRange(location: 0, length: result.length))
        return result
    }

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
