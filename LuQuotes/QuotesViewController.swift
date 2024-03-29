//
//  ViewController.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import UIKit

class QuotesViewController: UIPageViewController {
    @IBOutlet var bookmarkBarButtonItem: UIBarButtonItem!
    @IBOutlet var previousCategoryBarButtonItem: UIBarButtonItem!
    @IBOutlet var nextCategoryBarButtonItem: UIBarButtonItem!
    @IBOutlet var previousQuoteBarButtonItem: UIBarButtonItem!
    @IBOutlet var nextQuoteBarButtonItem: UIBarButtonItem!

    private var library: Library!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.library = Library()
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = .systemBackground

        if let current = self.library.quote(at: UserDefaults.standard.currentIndex, in: UserDefaults.standard.currentCategory) {
            self.setCurrent(current, direction: .forward, animated: false)
        }
    }

    func setCurrent (at index: Int, in category: Category) {
        if let quote = self.library.quote(at: index, in: category) {
            self.setCurrent(quote, direction: .forward, animated: false)
        }
    }

    func setCurrent (_ current: Quote, direction: UIPageViewController.NavigationDirection, animated: Bool) {
        if let viewController = self.quoteViewController(for: current) {
            UserDefaults.standard.currentIndex = current.index
            UserDefaults.standard.currentCategory = current.category
            self.setViewControllers([viewController], direction: direction, animated: animated, completion: nil)
            self.updateBookmarkButton(for: current)
            self.updateNavigationButtons(for: current)
        }
    }

    private func updateBookmarkButton (for quote: Quote) {
        self.bookmarkBarButtonItem.image = self.library.contains(bookmark: quote.bookmark) ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
    }

    private func updateNavigationButtons (for quote: Quote) {
        self.nextCategoryBarButtonItem.isEnabled = self.library.quote(after: quote) != nil
        self.nextQuoteBarButtonItem.isEnabled = self.library.quote(after: quote) != nil
        self.previousCategoryBarButtonItem.isEnabled = self.library.quote(before: quote) != nil
        self.previousQuoteBarButtonItem.isEnabled = self.library.quote(before: quote) != nil
    }

    // MARK: - Actions

    @IBAction func showMenuBarButtonItemPressed (_ button: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: NSLocalizedString("MenuOpenForumTitle", comment: "Main menu entry"), style: .default) { _ in
            UIApplication.shared.open(UserDefaults.standard.forumUrl)
        })

        alert.addAction(UIAlertAction(title: NSLocalizedString("MenuOpenSettingsTitle", comment: "Main menu entry"), style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })

        alert.addAction(UIAlertAction(title: NSLocalizedString("MenuCancelTitle", comment: "Main menu entry"), style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func bookmarkBarButtonItemPressed (_ button: UIBarButtonItem) {
        if let quote = (self.viewControllers?.first as? QuoteViewController)?.quote {
            self.library.toggle(bookmark: quote.bookmark)
            self.updateBookmarkButton(for: quote)
        }
    }

    @IBAction func previousCategoryBarButtonItemPressed (_ button: UIBarButtonItem) {
        guard let current = (self.viewControllers?.first as? QuoteViewController)?.quote else {
            return
        }

        if let category = current.category.previous, let previous = self.library.lastQuote(in: category) {
            self.setCurrent(previous, direction: .reverse, animated: true)
        } else if let previous = self.library.firstQuote(in: current.category), previous != current {
            self.setCurrent(previous, direction: .reverse, animated: true)
        }
    }

    @IBAction func nextCategoryBarButtonItemPressed (_ button: UIBarButtonItem) {
        guard let current = (self.viewControllers?.first as? QuoteViewController)?.quote else {
            return
        }

        if let category = current.category.next, let next = self.library.firstQuote(in: category) {
            self.setCurrent(next, direction: .forward, animated: true)
        } else if let next = self.library.lastQuote(in: current.category), next != current {
            self.setCurrent(next, direction: .forward, animated: true)
        }
    }

    @IBAction func previousQuoteBarButtonItemPressed (_ button: UIBarButtonItem) {
        guard let current = (self.viewControllers?.first as? QuoteViewController)?.quote else {
            return
        }
        if let previous = self.library.quote(before: current) {
            self.setCurrent(previous, direction: .reverse, animated: true)
        }
    }

    @IBAction func nextQuoteBarButtonItemPressed (_ button: UIBarButtonItem) {
        guard let current = (self.viewControllers?.first as? QuoteViewController)?.quote else {
            return
        }
        if let next = self.library.quote(after: current) {
            self.setCurrent(next, direction: .forward, animated: true)
        }
    }

    // MARK: - Navigation

    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        if segue.identifier == "UnwindBookmarks", let source = segue.source as? BookmarksViewController, let bookmark = source.selection,
            let quote = self.library.quote(at: bookmark) {
            self.setCurrent(quote, direction: .forward, animated: false)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookmarks", let destination = segue.destination as? BookmarksViewController {
            destination.library = self.library
            destination.popoverPresentationController?.delegate = self
        }
    }
}

extension QuotesViewController: UIPopoverPresentationControllerDelegate {
    func presentationControllerDidDismiss (_ presentationController: UIPresentationController) {
        if presentationController.presentedViewController is BookmarksViewController, let current = (self.viewControllers?.first as? QuoteViewController)?.quote {
            self.updateBookmarkButton(for: current)
            self.updateNavigationButtons(for: current)
        }
    }
}

extension QuotesViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let current = (pageViewController.viewControllers?.first as? QuoteViewController)?.quote {
            UserDefaults.standard.currentIndex = current.index
            UserDefaults.standard.currentCategory = current.category
            self.updateBookmarkButton(for: current)
            self.updateNavigationButtons(for: current)
        }
    }
}

extension QuotesViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let current = (viewController as? QuoteViewController)?.quote,
            let previous = self.library.quote(before: current)
        else {
            return nil
        }

        return self.quoteViewController(for: previous)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let current = (viewController as? QuoteViewController)?.quote,
            let next = self.library.quote(after: current)
        else {
            return nil
        }

        return self.quoteViewController(for: next)
    }

    private func quoteViewController (for quote: Quote) -> QuoteViewController? {
        guard let result = storyboard?.instantiateViewController(withIdentifier: "QuoteViewController") as? QuoteViewController else {
            return nil
        }

        result.quote = quote
        return result
    }
}
