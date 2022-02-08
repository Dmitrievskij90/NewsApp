//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import Firebase
import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask )
        print(documentDirectorypath)

        setupRootViewController()

        return true
    }

    private func setupRootViewController() {
        let navigationController = UINavigationController(rootViewController: WelcomeController())
        navigationController.navigationBar.isHidden = true
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
