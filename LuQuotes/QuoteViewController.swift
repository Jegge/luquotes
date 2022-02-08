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

        let paragraph = NSMutableParagraphStyle()
        paragraph.hyphenationFactor = 0.8
        paragraph.alignment = .justified

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraph,
            .font: self.contentTextView.font!,
            .foregroundColor: self.contentTextView.textColor!
        ]

        self.contentTextView.attributedText = NSAttributedString(string: self.quote.message, attributes: attributes)
    }
}
