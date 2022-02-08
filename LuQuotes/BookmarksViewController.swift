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
        self.entries = Category.allCases.flatMap { self.library.bookmarks(in: $0).sorted(by: <) }
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

        case .quote(category: let category, index: let index):
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
            (cell as? QuoteCell)?.quote = self.library.quote(at: index, in: category)
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
            self.library.remove(bookmark: self.entries[indexPath.row])
            self.entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryCell = sender as? CategoryCell {
            self.selection = categoryCell.category.bookmark
        }
        if let quoteCell = sender as? QuoteCell {
            self.selection = quoteCell.quote?.bookmark
        }
    }
}
