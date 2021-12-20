//
//  NewsSearchControllerViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 20.12.2021.
//

import Foundation

class NewsSearchControllerViewModel {
    var newsBySearch: Box<[NewsCellModel]> = Box([])
    var term = ""
    var stopAnimating: (()->())?
    private var defaultLocation = CategoryManager.shared.loadUser().country

    init() {
        addObserver()
        fetchNews(defaultLocation, category: term)
    }

    func viewWillAppear() {
        defaultLocation = CategoryManager.shared.loadUser().country
    }

    func refreshData() {
        fetchNews(defaultLocation, category: term)
    }

    private func addObserver() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateStockCompaniesSet),
            name: Notification.Name("term"),
            object: nil)
    }

    @objc private func updateStockCompaniesSet(_ notification: Notification) {
        if let loc = notification.object {
            guard let copm = loc as? String else {return}
            term = copm
            refreshData()
        }
    }

    private func fetchNews(_ country: String, category: String) {
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
        NetworkService.shared.fetchNews(searchTerm: term, preferredCountry: country) {  (results, error) in
            if let err = error {
                print("Can't fetch stock data", err)
            }
//            dispatchGroup.leave()
            if let res = results?.articles  {
                self.newsBySearch.value = res.compactMap{NewsCellModel(source: $0.source.name, date: $0.publishedAt, title: $0.title ?? "", image: $0.urlToImage ?? "", description: $0.description ?? "", url: $0.url, publishedAt: $0.publishedAt)}
            }
//            dispatchGroup.notify(queue: .main) { [weak self] in
//                self?.stopAnimating?()
//            }
        }
    }
}
