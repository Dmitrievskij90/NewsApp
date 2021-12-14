//
//  TodayCellViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.12.2021.
//

import Foundation

public class TodayCellViewModel {
    var todayNews: Box<[TodayCellModel]> = Box([])
    var stockData: Box<[StockHeaderCellModel]> = Box([])
    private var defaultLocation = CategoryManager.shared.loadUser().country
    private var stockCompaniesSet = CategoryManager.shared.loadStockCompaniesSet().sorted().joined(separator: ",")



    init() {
        fetchTodayNews(with: defaultLocation)
        fetchStockData(with: stockCompaniesSet)
        addObservers()
    }

    func viewWillAppear() {
        stockCompaniesSet = CategoryManager.shared.loadStockCompaniesSet().sorted().joined(separator: ",")
        defaultLocation = CategoryManager.shared.loadUser().country
    }

    func refreshData() {
        fetchStockData(with: stockCompaniesSet)
        fetchTodayNews(with: defaultLocation)
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
            guard let copm = loc as? Set<String> else {return}
            fetchStockData(with: copm.sorted().joined(separator: ","))
        }
    }

    @objc private func updateCountryforTodayNews(_ notification: Notification) {
        if let location = notification.object as? User {
            fetchTodayNews(with: location.country)
        }
    }

    private func fetchStockData(with companies: String) {
        NetworkService.shared.fetchStockData(searchedStockCompanies: companies) { (results, error) in
            if let err = error {
                print("Can't fetch stock data", err)
            }
            if let res = results {
                self.stockData.value = res.compactMap{StockHeaderCellModel(symbol: $0.symbol, price: $0.price)}
            }
        }
    }
    
    private func fetchTodayNews(with country: String) {
        NetworkService.shared.fetchTodayNews(preferredCountry: country) { (results, error) in
            if let err = error {
                print("Can't fetch today news", err)
            }
            if let res = results?.articles {
                self.todayNews.value = res.compactMap{TodayCellModel(source: $0.source.name, date: $0.publishedAt, title: $0.title ?? "", image: $0.urlToImage ?? "", description: $0.description ?? "", url: $0.url)}
            }
        }
    }
}

