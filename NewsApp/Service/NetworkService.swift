//
//  NetworkService.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 05.09.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()

    func fetchNews(searchTerm: String, preferredCountry: String, completion: @escaping (NewsData?, Error?) -> ()) {

        let urlString =  "https://newsapi.org/v2/everything?q=\(searchTerm)&language=\(preferredCountry)&sortBy=publishedAt&pageSize=100&apiKey=61bba430f9444209af20b7856ae3d12e"

        fetchData(with: urlString, completion: completion)
    }

    func fetchTodayNews(preferredCountry: String, completion: @escaping (NewsData?, Error?) -> ()) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(preferredCountry)&pageSize=100&apiKey=61bba430f9444209af20b7856ae3d12e"

        fetchData(with: urlString, completion: completion)
    }

    func fetchCategoriesNews(preferredCountry: String, preferredCategoty: String, completion: @escaping (NewsData?, Error?) -> ()) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(preferredCountry)&category=\(preferredCategoty)&pageSize=100&apiKey=61bba430f9444209af20b7856ae3d12e"

        fetchData(with: urlString, completion: completion)
    }


    func fetchStockData(searchedStockCompanies: String, completion: @escaping ([StockData]?, Error?) -> ()) {
        let urlString = "https://api.finage.co.uk/last/trade/stocks?symbols=\(searchedStockCompanies)&apikey=API_KEY44UIHMO0PMWXR4Y325YXXZIE5ZOQBA74"

        fetchData(with: urlString, completion: completion)
    }

    func fetchData<T: Codable>(with urlString: String, completion: @escaping (T?, Error?) -> ()) {
                                                    
        guard let url = URL(string: urlString) else {
            print("Can't load url")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, responce, error) in

            if let err = error {
                print("Failed fatch data \(err)")
            }
            
            guard let safeData = data else {
                return
            }

            do {
                let res = try JSONDecoder().decode(T.self, from: safeData)
                completion(res, nil)
            } catch let jsonError{
                completion(nil, jsonError)
            }
        }.resume()
    }
    
}
