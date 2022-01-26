//
//  BaseTabBarController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import FirebaseAuth
import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black

        viewControllers = [
            createNavController(viewController: TodayController(), title: "Today", imageName: "iphone"),
            createNavController(viewController: FavoriteCategoriesViewController(), title: "Favorite", imageName: "star"),
            createNavController(viewController: NewsSearchController(), title: "Search", imageName: "magnifyingglass"),
            createNavController(viewController: ProfileViewController(), title: "Profile", imageName: "person")
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Auth.auth().currentUser?.reload()
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
}
