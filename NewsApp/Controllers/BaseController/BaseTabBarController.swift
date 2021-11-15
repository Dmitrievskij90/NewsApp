//
//  BaseTabBarController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import UIKit
import FirebaseAuth

class BaseTabBarController: UITabBarController {
//    private var categoriesSet:Set = ["Business", "Entertainment", "Health", "Science", "Sports", "Technology"]
//    private var categoriesStruct = [
//        Categories(name: "Business", isFavorited: true),
//        Categories(name: "Entertainment", isFavorited: true),
//        Categories(name: "Health", isFavorited: true),
//        Categories(name: "Science", isFavorited: true),
//        Categories(name: "Sports", isFavorited: true),
//        Categories(name: "Technology", isFavorited: true),
//    ]
//    private var stockCompaniesSet:Set  = ["AMZN", "AAPL", "KO", "FB", "GOGL", "IBM", "INTC", "MCD", "MSFT", "NFLX", "NKE", "PEP", "SBUX", "TSLA", "V"]
//    private var stockCompaniesStruct = [
//        StockCompanies(name: "Apple", symbol: "AAPL", isFavorited: true),
//        StockCompanies(name: "Amazon", symbol: "AMZN", isFavorited: true),
//        StockCompanies(name: "Facebook", symbol: "FB", isFavorited: true),
//        StockCompanies(name: "Google", symbol: "GOGL", isFavorited: true),
//        StockCompanies(name: "IBM", symbol: "IBM", isFavorited: true),
//        StockCompanies(name: "Intel", symbol: "INTC", isFavorited: true),
//        StockCompanies(name: "Coca-Cola", symbol: "KO", isFavorited: true),
//        StockCompanies(name: "McDonald’s", symbol: "MCD", isFavorited: true),
//        StockCompanies(name: "Microsoft", symbol: "MSFT", isFavorited: true),
//        StockCompanies(name: "Netflix", symbol: "NFLX", isFavorited: true),
//        StockCompanies(name: "Nike", symbol: "NKE", isFavorited: true),
//        StockCompanies(name: "Pepsi", symbol: "PEP", isFavorited: true),
//        StockCompanies(name: "Starbucks", symbol: "SBUX", isFavorited: true),
//        StockCompanies(name: "Tesla", symbol: "TSLA", isFavorited: true),
//        StockCompanies(name: "Visa", symbol: "V", isFavorited: true),
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
//        loadCategories()

        viewControllers = [
            createNavController(viewController: TodayController(), title: "Today", imageName: "iphone"),
            createNavController(viewController: FavouriteCategoriesViewController(), title: "Favorite", imageName: "star"),
            createNavController(viewController: NewsSearchController(), title: "Search", imageName: "magnifyingglass"),
            createNavController(viewController: ProfileViewController(), title: "Profile", imageName: "person")
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Auth.auth().currentUser?.reload()
//        print(AppSettingsManager.shared.userLogin)
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

//    private func loadCategories() {
//        let notFirsAppLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
//
//        if !notFirsAppLaunch {
//            CategoryManager.shared.saveCategoriesSet(with: categoriesSet)
//            CategoryManager.shared.saveCategoriesStruct(with: categoriesStruct)
//            CategoryManager.shared.saveStockCompaniesSet(with: stockCompaniesSet)
//            CategoryManager.shared.saveStockCompaniesStruct(with: stockCompaniesStruct)
//            UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
//        }
//    }
}
