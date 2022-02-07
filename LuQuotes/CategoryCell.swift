//
//  CategoryCell.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    var category: Category = .introduction {
        didSet {
            self.iconImageView.image = UIImage(named: "logo")?.withTintColor(self.category.color)
            self.titleLabel.text = self.category.localizedDescription
        }
    }
}
