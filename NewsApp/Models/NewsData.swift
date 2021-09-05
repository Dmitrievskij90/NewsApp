//
//  NewsData.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 05.09.2021.
//

import Foundation

struct NewsData: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let author: String
    let title: String
    let urlToImage: String
    let content: String
}
