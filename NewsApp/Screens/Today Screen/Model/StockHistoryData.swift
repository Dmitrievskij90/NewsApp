//
//  StockHistoryData.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 02.11.2021.
//

import Foundation

struct StockHistoryData: Codable {
    let values: [Values]
}

struct Values: Codable {
    let datetime: String
    let close: String
    let open: String
}
