//
//  TodayCellViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.12.2021.
//

import Foundation

public class TodayCellViewModel {
    var todayNews: Box<[TodayCellModel]> = Box([])
    static private var defaultAddress = CategoryManager.shared.loadUser()

     init() {
        fetchWeatherForLocation(Self.defaultAddress.country)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateDefaultAddress),
            name: Notification.Name("user"),
            object: nil)
    }

    @objc func updateDefaultAddress(_ notification: Notification) {
        if let loc = notification.object as? User {
            fetchWeatherForLocation(loc.country)
        }
    }

   private func fetchWeatherForLocation(_ location: String) {
        NetworkService.shared.fetchTodayNews(preferredCountry: location) { (results, error) in
            if let err = error {
                print("Can't fetch today news", err)
            }
            if let res = results?.articles {
                self.todayNews.value = res.compactMap{TodayCellModel(source: $0.source.name, date: $0.publishedAt, title: $0.title ?? "", image: $0.urlToImage ?? "", description: $0.description ?? "")}
            }
        }
    }
}
