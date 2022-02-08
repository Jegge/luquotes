//
//  QuoteCell.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import UIKit

class QuoteCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    var quote: Quote? {
        didSet {
            self.titleLabel.text = self.quote?.message
        }
    }
}
