//
//  NewsSearchControllerViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 20.12.2021.
//

import Foundation

class NewsSearchControllerViewModel {
    var newsBySearch: Box<[NewsCellModel]> = Box([])
    var stopAnimating: (() -> Void)?
    
    private var networkService: NetworkServiceSearchNewsProtocol = NetworkService()
    private var defaultLocation = AppSettingsManager.shared.loadUser().country
    private var term = ""

    init() {
        addObserver()
        fetchNews(defaultLocation, category: term)
    }

    func viewWillAppear() {
        defaultLocation = AppSettingsManager.shared.loadUser().country
    }

    private func refreshData() {
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
            guard let copm = loc as? String else {
                return
            }
            term = copm
            refreshData()
        }
    }

    private func fetchNews(_ country: String, category: String) {
        networkService.searchNews(searchTerm: term, preferredCountry: country) { results, error in
            if let err = error {
                print("Can't fetch stock data", err)
            }
            if let res = results?.articles {
                self.newsBySearch.value = res.compactMap { NewsCellModel(source: $0.source.name, date: $0.publishedAt, title: $0.title ?? "", image: $0.urlToImage ?? "", description: $0.description ?? "", url: $0.url, publishedAt: $0.publishedAt) }
            }
        }
    }
}
