//
//  StockCompanies.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 30.10.2021.
//

import Foundation

struct StockCompanies: Codable {
    let name: String
    let symbol: String
    var isFavorited: Bool
}
