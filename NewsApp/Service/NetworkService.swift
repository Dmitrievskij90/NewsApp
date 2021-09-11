//
//  NetworkService.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 05.09.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()

    func fetchNews(searchTerm: String, completion: @escaping (NewsData?, Error?) -> ()) {

        let urlString = "https://newsapi.org/v2/everything?q=\(searchTerm)&sortBy=publishedAt&pageSize=100&apiKey=61bba430f9444209af20b7856ae3d12e"

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
