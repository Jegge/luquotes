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

    private var library: Library = Library()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self

        if let current = self.library.quote(at: UserDefaults.standard.currentIndex, in: UserDefaults.standard.currentCategory) {
            self.setCurrent(current, direction: .forward, animated: false)
        }
    }

    private func setCurrent(_ current: Quote, direction: UIPageViewController.NavigationDirection, animated: Bool) {
        if let viewController = self.quoteViewController(for: current) {
            UserDefaults.standard.currentIndex = current.index
            UserDefaults.standard.currentCategory = current.category
            self.setViewControllers([viewController], direction: direction, animated: animated, completion: nil)
            self.updateBookmarkButton(for: current)
            self.updateNavigationButtons(for: current)
        }
    }

    private func updateBookmarkButton (for quote: Quote) {
        self.bookmarkBarButtonItem.image = self.library.hasBookmark(for: quote) ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
    }

    private func updateNavigationButtons (for quote: Quote) {
        self.nextCategoryBarButtonItem.isEnabled = self.library.quote(after: quote) != nil
        self.previousCategoryBarButtonItem.isEnabled = self.library.quote(before: quote) != nil
    }

    @IBAction func openForumBarButtonItemPressed (_ button: UIBarButtonItem) {
        if let url = URL(string: "https://www.liberationunleashed.com/nation/") {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func bookmarkBarButtonItemPressed (_ button: UIBarButtonItem) {
        if let quote = (self.viewControllers?.first as? QuoteViewController)?.quote {
            self.library.toggleBookmark(for: quote)
            self.updateBookmarkButton(for: quote)
        }
    }

    @IBAction func previousCategoryBarButtonItemPressed (_ button: UIBarButtonItem) {
        guard let current = (self.viewControllers?.first as? QuoteViewController)?.quote else {
            return
        }

        if let category = current.category.previous, let previous = self.library.last(in: category) {
            self.setCurrent(previous, direction: .reverse, animated: true)
        } else if let previous = self.library.first(in: current.category), previous != current {
            self.setCurrent(previous, direction: .reverse, animated: true)
        }
    }

    @IBAction func nextCategoryBarButtonItemPressed (_ button: UIBarButtonItem) {
        guard let current = (self.viewControllers?.first as? QuoteViewController)?.quote else {
            return
        }

        if let category = current.category.next, let next = self.library.first(in: category) {
            self.setCurrent(next, direction: .forward, animated: true)
        } else if let next = self.library.last(in: current.category), next != current {
            self.setCurrent(next, direction: .forward, animated: true)
        }
    }

    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        if segue.identifier == "UnwindBookmarks", let source = segue.source as? BookmarksViewController {
            switch source.selection {
            case .category(category: let category):
                if let quote = self.library.first(in: category) {
                    self.setCurrent(quote, direction: .forward, animated: false)
                }
            case .quote(quote: let quote):
                self.setCurrent(quote, direction: .forward, animated: false)
            default:
                break
            }
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
