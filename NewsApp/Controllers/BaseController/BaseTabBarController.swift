//
//  BaseTabBarController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import UIKit

class BaseTabBarController: UITabBarController {

    private var categoriesSet:Set = ["business", "entertainment", "general", "health", "science", "sports", "technology"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        loadCategories()

        viewControllers = [
            createNavController(viewController: TodayController(), title: "Today", imageName: "iphone"),
            createNavController(viewController: FavouriteCategoriesViewController(), title: "Favorite", imageName: "star"),
            createNavController(viewController: NewsSearchController(), title: "Search", imageName: "magnifyingglass"),
            createNavController(viewController: ProfileViewController(), title: "Profile", imageName: "person")
        ]
    }

    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.image = UIImage(systemName: imageName)
        UITabBar.appearance().tintColor = .init(hex: 0xBE1FBB)

        return navController
    }

    private func loadCategories() {
        let notFirsAppLaunch = UserDefaults.standard.bool(forKey: "isrue")
        print(notFirsAppLaunch)

        if !notFirsAppLaunch {
            CategoryManager.shared.saveCategories(with: categoriesSet)
            UserDefaults.standard.setValue(true, forKey: "isrue")
        }
    }
}
