//
//  NetworkServiceProtocols.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 20.01.2022.
//

import Foundation

protocol NetworkServiceSearchNewsProtocol {
    func searchNews(searchTerm: String, preferredCountry: String, completion: @escaping (NewsData?, Error?) -> ())
}

protocol NetworkServiceFetchTodayNewsProtocol {
    func fetchTodayNews(preferredCountry: String, completion: @escaping (NewsData?, Error?) -> ())
    func fetchStockData(searchedStockCompanies: String, completion: @escaping ([StockData]?, Error?) -> ())
}

protocol NetworkServiceFetchCategoriesNewsProtocol {
    func fetchCategoriesNews(preferredCountry: String, preferredCategoty: String, completion: @escaping (NewsData?, Error?) -> ())
}

protocol NetworkServiceFetchStockChartDataProtocol {
    func fetchStockChartData(searchedStockCompany: String, completion: @escaping (StockHistoryData?, Error?) -> ())
}

typealias NetworkServiceProtocol = NetworkServiceSearchNewsProtocol & NetworkServiceFetchTodayNewsProtocol & NetworkServiceFetchCategoriesNewsProtocol & NetworkServiceFetchStockChartDataProtocol


