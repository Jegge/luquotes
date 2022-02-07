//
//  BookmarksViewController.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import UIKit

class BookmarksViewController: UITableViewController {

    private var entries: [Bookmark] = []

    var library: Library!
    var selection: Bookmark?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.entries = Category.allCases.flatMap {  [.category(category: $0)] + self.library.bookmarks(in: $0) }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selection = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch self.entries[indexPath.row] {
        case .category(let category):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            (cell as? CategoryCell)?.category = category
            return cell

        case .quote(let quote):
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
            (cell as? QuoteCell)?.quote = quote
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch self.entries[indexPath.row] {
        case .quote(quote: _):
            return true
        default:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.library.bookmarks.remove(self.entries[indexPath.row])
            self.entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryCell = sender as? CategoryCell {
            self.selection = .category(category: categoryCell.category)
        }
        if let quoteCell = sender as? QuoteCell {
            self.selection = .quote(quote: quoteCell.quote)
        }
    }
}
