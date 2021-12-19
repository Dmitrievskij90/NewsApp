//
//  FullSceenCategoriesViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 16.12.2021.
//

import Foundation

class FullSceenCategoriesViewModel {
    var categoryNews: Box<[NewsCellModel]> = Box([])
    private var defaultLocation = CategoryManager.shared.loadUser().country
    var category: String
    var stopAnimating: (()->())?

    init(category: String) {
        self.category = category
        fetchCategoryNews(defaultLocation, category: category)
    }

    func viewWillAppear() {
        defaultLocation = CategoryManager.shared.loadUser().country
    }

    func refreshData() {
        fetchCategoryNews(defaultLocation, category: category)
    }

    private func fetchCategoryNews(_ country: String, category: String) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        NetworkService.shared.fetchCategoriesNews(preferredCountry: country, preferredCategoty: category) {  (results, error) in
            if let err = error {
                print("Can't fetch stock data", err)
            }
            if let res = results?.articles  {
                self.categoryNews.value = res.compactMap{NewsCellModel(author: $0.author ?? "", title: $0.title ?? "", image: $0.urlToImage ?? "")}
            }
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.stopAnimating?()
            }
        }
    }
}
