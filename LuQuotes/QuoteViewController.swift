//
//  QuoteViewController.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import UIKit

class QuoteViewController: UIViewController {
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var contentTextView: UITextView!

    var quote: Quote = Quote(index: 0, category: .introduction, message: "Lorem ipsum")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.categoryLabel.text = self.quote.category.localizedDescription
        self.categoryLabel.textColor = self.quote.category.color
        self.categoryImage.image = UIImage(named: "logo")?.withTintColor(self.quote.category.color)

        // set the default style to justified, can be overridden in the quote
        let message = self.quote.message.hasPrefix("<div")
            ? self.quote.message
            : "<div style=\"text-align: justify\">" + self.quote.message + "</div>"

        self.contentTextView.attributedText = (NSAttributedString(html: message) ?? NSAttributedString(string: ""))
            .setting(textColor: self.contentTextView.textColor!, backgroundColor: self.contentTextView.backgroundColor!)
            .setting(hyphenationFactor: 0.8)
            .setting(font: self.contentTextView.font!)
    }
}
