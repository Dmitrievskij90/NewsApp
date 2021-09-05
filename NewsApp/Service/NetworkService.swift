//
//  NetworkService.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 05.09.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()

    func fetchData<T: Codable>(with urlString: String, completion: @escaping (T?, Error?) -> ()) {
                                                    
        guard let url = URL(string: urlString) else {
            fatalError("Can't load url")
        }

        URLSession.shared.dataTask(with: url) { (data, responce, error) in

            if let err = error {
                fatalError("Failed fatch data \(err)")
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
