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
    var author: String?
    var urlToImage: String?
    let title: String
    let content: String
    let description: String
    let publishedAt: String
    let source: Source
}

struct Source: Codable {
    let name: String
}
