//
//  DefaultParameters.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 18.11.2021.
//

import Foundation
import UIKit

enum DefaultParameters {

    static private let view = UIScreen.main.bounds

    static let  buttonHeight = view.height / 17
    static let  buttonWidth = view.width * 0.75

     static var categoriesSet:Set = ["Business", "Entertainment", "Health", "Science", "Sports", "Technology"]
     static var categoriesStruct = [
        Categories(name: "Business", isFavorited: true),
        Categories(name: "Entertainment", isFavorited: true),
        Categories(name: "Health", isFavorited: true),
        Categories(name: "Science", isFavorited: true),
        Categories(name: "Sports", isFavorited: true),
        Categories(name: "Technology", isFavorited: true),
    ]
     static var stockCompaniesSet:Set  = ["AMZN", "AAPL", "KO", "FB", "GOGL", "IBM", "INTC", "MCD", "MSFT", "NFLX", "NKE", "PEP", "SBUX", "TSLA", "V"]
     static var stockCompaniesStruct = [
        StockCompanies(name: "Apple", symbol: "AAPL", isFavorited: true),
        StockCompanies(name: "Amazon", symbol: "AMZN", isFavorited: true),
        StockCompanies(name: "Facebook", symbol: "FB", isFavorited: true),
        StockCompanies(name: "Google", symbol: "GOGL", isFavorited: true),
        StockCompanies(name: "IBM", symbol: "IBM", isFavorited: true),
        StockCompanies(name: "Intel", symbol: "INTC", isFavorited: true),
        StockCompanies(name: "Coca-Cola", symbol: "KO", isFavorited: true),
        StockCompanies(name: "McDonald’s", symbol: "MCD", isFavorited: true),
        StockCompanies(name: "Microsoft", symbol: "MSFT", isFavorited: true),
        StockCompanies(name: "Netflix", symbol: "NFLX", isFavorited: true),
        StockCompanies(name: "Nike", symbol: "NKE", isFavorited: true),
        StockCompanies(name: "Pepsi", symbol: "PEP", isFavorited: true),
        StockCompanies(name: "Starbucks", symbol: "SBUX", isFavorited: true),
        StockCompanies(name: "Tesla", symbol: "TSLA", isFavorited: true),
        StockCompanies(name: "Visa", symbol: "V", isFavorited: true),
    ]

    static var user = User(name: "User")
}
