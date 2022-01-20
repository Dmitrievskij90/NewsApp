//
//  FullSceenCategoriesViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 16.12.2021.
//

import Foundation

class FullSceenCategoriesViewModel {
    var categoryNews: Box<[NewsCellModel]> = Box([])
    var category: String
    var stopAnimating: (()->())?
    private var defaultLocation = CategoryManager.shared.loadUser().country

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
                self.categoryNews.value = res.compactMap{NewsCellModel(source: $0.source.name, date: $0.publishedAt, title: $0.title ?? "", image: $0.urlToImage ?? "", description: $0.description ?? "", url: $0.url, publishedAt: $0.publishedAt)}
            }
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.stopAnimating?()
            }
        }
    }
}
