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

    private var font: UIFont!
    var quote: Quote = Quote(index: 0, category: .introduction, message: "Lorem ipsum")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.font = self.contentTextView.font!

        self.categoryLabel.text = self.quote.category.localizedDescription
        self.categoryLabel.textColor = self.quote.category.color
        self.categoryImage.image = UIImage(named: "logo")?.withTintColor(self.quote.category.color)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateMessage()
    }

    @objc func applicationDidBecomeActive () {
        self.updateMessage()
    }

    private func updateMessage () {
        // set the default style to justified, can be overridden in the quote
        let message = self.quote.message.hasPrefix("<div")
            ? self.quote.message
            : "<div style=\"text-align: justify\">" + self.quote.message + "</div>"

        self.contentTextView.attributedText = (NSAttributedString(html: message) ?? NSAttributedString(string: ""))
            .setting(textColor: self.contentTextView.textColor!, backgroundColor: self.contentTextView.backgroundColor!)
            .setting(hyphenationFactor: 0.8)
            .setting(font: self.font)
            .increasingFontSize(by: UserDefaults.standard.largeFont ? 5.0 : 0.0)
    }
}
