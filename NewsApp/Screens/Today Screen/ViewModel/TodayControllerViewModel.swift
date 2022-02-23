//
//  TodayCellViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.12.2021.
//

import Foundation

public class TodayControllerViewModel {
    var todayNews: Box<[TodayCellModel]> = Box([])
    var stockData: Box<[StockHeaderCellModel]> = Box([])
    var updateViews: (() -> Void)?

    private var networkService: NetworkServiceFetchTodayNewsProtocol = NetworkService()
    private var defaultLocation = AppSettingsManager.shared.loadUser().country
    private var stockCompaniesSet = CategoryManager.shared.loadStockCompaniesSet().sorted().joined(separator: ",")

    init() {
        fetchTodayNews(with: defaultLocation, with: stockCompaniesSet)
        addObservers()
    }

    func viewWillAppear() {
        stockCompaniesSet = CategoryManager.shared.loadStockCompaniesSet().sorted().joined(separator: ",")
        defaultLocation = AppSettingsManager.shared.loadUser().country
    }

    func refreshData() {
        fetchTodayNews(with: defaultLocation, with: stockCompaniesSet)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateCountryforTodayNews),
            name: Notification.Name("user"),
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateStockCompaniesSet),
            name: Notification.Name("stockCompaniesSet"),
            object: nil)
    }

    @objc private func updateStockCompaniesSet(_ notification: Notification) {
        if let loc = notification.object {
            guard let copm = loc as? Set<String> else {
                return
            }
            stockCompaniesSet = copm.sorted().joined(separator: ",")
            //            refreshData()
        }
    }

    @objc private func updateCountryforTodayNews(_ notification: Notification) {
        if let location = notification.object as? User {
            defaultLocation = location.country
            //            refreshData()
        }
    }

    private func fetchTodayNews(with country: String, with companies: String) {
        let todayNews: Box<[TodayCellModel]> = Box([])
        let stockData: Box<[StockHeaderCellModel]> = Box([])

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        networkService.fetchTodayNews(preferredCountry: country) { results, error in
            if let err = error {
                print("Can't fetch today news", err)
            }
            dispatchGroup.leave()
            if let res = results?.articles {
                todayNews.value = res.compactMap { TodayCellModel(source: $0.source.name, date: $0.publishedAt, title: $0.title ?? "", image: $0.urlToImage ?? "", description: $0.description ?? "", url: $0.url) }
            }
        }

        dispatchGroup.enter()
        networkService.fetchStockData(searchedStockCompanies: companies) { results, error in
            if let err = error {
                print("Can't fetch stock data", err)
            }
            dispatchGroup.leave()
            if let res = results {
                stockData.value = res.compactMap { StockHeaderCellModel(symbol: $0.symbol, price: $0.price) }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.todayNews = todayNews
            self?.stockData = stockData
            self?.updateViews?()
        }
    }
}
