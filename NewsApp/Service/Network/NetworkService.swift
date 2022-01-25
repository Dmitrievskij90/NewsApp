//
//  NetworkService.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 05.09.2021.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    func searchNews(searchTerm: String, preferredCountry: String, completion: @escaping (NewsData?, Error?) -> Void) {
        if preferredCountry == "us" {
            let urlString = "https://newsapi.org/v2/everything?q=\(searchTerm)&language=en&sortBy=publishedAt&pageSize=100&apiKey=61bba430f9444209af20b7856ae3d12e"
            fetchData(with: urlString, completion: completion)
        }

        let urlString = "https://newsapi.org/v2/everything?q=\(searchTerm)&language=\(preferredCountry)&sortBy=publishedAt&pageSize=100&apiKey=61bba430f9444209af20b7856ae3d12e"

        fetchData(with: urlString, completion: completion)
    }

    func fetchTodayNews(preferredCountry: String, completion: @escaping (NewsData?, Error?) -> Void) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(preferredCountry)&pageSize=100&apiKey=61bba430f9444209af20b7856ae3d12e"

        fetchData(with: urlString, completion: completion)
    }

    func fetchCategoriesNews(preferredCountry: String, preferredCategoty: String, completion: @escaping (NewsData?, Error?) -> Void) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(preferredCountry)&category=\(preferredCategoty)&pageSize=100&apiKey=61bba430f9444209af20b7856ae3d12e"

        fetchData(with: urlString, completion: completion)
    }

    func fetchStockData(searchedStockCompanies: String, completion: @escaping ([StockData]?, Error?) -> Void) {
        let urlString = "https://api.finage.co.uk/last/trade/stocks?symbols=\(searchedStockCompanies)&apikey=API_KEY87BC53J2JGW1J7D48X8UGC4I0AGMJJ51"

        fetchData(with: urlString, completion: completion)
    }

    func fetchStockChartData(searchedStockCompany: String, completion: @escaping (StockHistoryData?, Error?) -> Void) {
        let urlString = "https://api.twelvedata.com/time_series?symbol=\(searchedStockCompany)&interval=1day&apikey=d907af5f4dd84e25ad29b6387819d146"

        fetchData(with: urlString, completion: completion)
    }

    func fetchData<T: Codable>(with urlString: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Can't load url")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let err = error {
                print("Failed fatch data \(err)")
            }
            
            guard let safeData = data else {
                return
            }

            do {
                let res = try JSONDecoder().decode(T.self, from: safeData)
                completion(res, nil)
            } catch {
                completion(nil, error)
            }
        }
        .resume()
    }
}
