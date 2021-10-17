//
//  BaseTabBarController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import UIKit

class BaseTabBarController: UITabBarController {

    private var categoriesSet:Set = ["Business", "Entertainment", "Health", "Science", "Sports", "Technology"]
    private var categoriesStruct = [
        Categories(name: "Business", isFavorited: true),
        Categories(name: "Entertainment", isFavorited: true),
        Categories(name: "Health", isFavorited: true),
        Categories(name: "Science", isFavorited: true),
        Categories(name: "Sports", isFavorited: true),
        Categories(name: "Technology", isFavorited: true),
    ]

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
        UITabBar.appearance().tintColor = .init(hex: 0xDB6400)

        return navController
    }

    private func loadCategories() {
        let notFirsAppLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")

        if !notFirsAppLaunch {
            CategoryManager.shared.saveCategoriesSet(with: categoriesSet)
            CategoryManager.shared.saveCategoriesStruct(with: categoriesStruct)
            UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
        }
    }
}
