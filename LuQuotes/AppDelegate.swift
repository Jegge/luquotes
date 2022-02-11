//
//  AppDelegate.swift
//  LuQuotes
//
//  Created by Sebastian Boettcher on 07.02.22.
//

import UIKit
import CoreSpotlight

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UserDefaults.standard.register()

        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType != CSSearchableItemActionType {
            return false
        }

        guard
            let path = (userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String)?.components(separatedBy: "-"),
            path.count == 2,
            let category = Category(rawValue: Int(path[0]) ?? -1),
            let index = Int(path[1]),
            let navigationController = self.window?.rootViewController as? UINavigationController
        else {
            return false
        }

        navigationController.popToRootViewController(animated: false)
        if let quotesViewController = navigationController.visibleViewController as? QuotesViewController {
            quotesViewController.setCurrent(at: index, in: category)
            return true
        }

        return false
    }
}
