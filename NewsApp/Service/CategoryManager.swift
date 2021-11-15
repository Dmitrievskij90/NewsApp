//
//  CategoryManager.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 03.10.2021.
//

import UIKit

class CategoryManager {
    static let shared = CategoryManager()
//    private var documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
    private let fileManager = FileManager.default

    //MARK: - categories set data manipulation methods
    //MARK: -
    func saveCategoriesSet(with set: Set<String>) {
        let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
        let folderPath = documentDirectorypath
        guard let path = folderPath else {
            return
        }
        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(set)
        let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
        FileManager.default.createFile(atPath: dataPath!.path, contents: data, attributes: nil)
    }

    func loadCategoriesSet() -> Set<String>{
        let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
        var categorySet = Set<String>()
        let folderPath = documentDirectorypath
        let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
        if let newData = FileManager.default.contents(atPath: dataPath!.path) {
            categorySet = try! JSONDecoder().decode(Set<String>.self, from: newData)
        }
        return categorySet
    }

    //MARK: - categories struct data manipulation methods
    //MARK: -
    func saveCategoriesStruct(with categories: [Categories]) {
         let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
        let folderPath = documentDirectorypath
        guard let path = folderPath else {
            return
        }

        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(categories)
        let dataPath = folderPath?.appendingPathComponent("categoriesStruct.json")
        FileManager.default.createFile(atPath: dataPath!.path, contents: data, attributes: nil)
    }

    func loadCategoriesStruct() -> [Categories]{
        let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
        var categories = [Categories]()
        let folderPath = documentDirectorypath
        let dataPath = folderPath?.appendingPathComponent("categoriesStruct.json")
        if let newData = FileManager.default.contents(atPath: dataPath!.path) {
            categories = try! JSONDecoder().decode([Categories].self, from: newData)
        }
        return categories
    }

    //MARK: - stock companies set data manipulation methods
    //MARK: -
    func saveStockCompaniesSet(with set: Set<String>) {
        let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
        let folderPath = documentDirectorypath
        guard let path = folderPath else {
            return
        }

        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(set)
        let dataPath = folderPath?.appendingPathComponent("stockSet.json")
        FileManager.default.createFile(atPath: dataPath!.path, contents: data, attributes: nil)

    }

    func loadStockCompaniesSet() -> Set<String>{
        let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
        var stockSet = Set<String>()
        let folderPath = documentDirectorypath
        let dataPath = folderPath?.appendingPathComponent("stockSet.json")
        if let newData = FileManager.default.contents(atPath: dataPath!.path) {
            stockSet = try! JSONDecoder().decode(Set<String>.self, from: newData)
        }
        return stockSet
    }

    //MARK: - stock companies struct data manipulation methods
    //MARK: -
    func saveStockCompaniesStruct(with categories: [StockCompanies]) {
        let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
        let folderPath = documentDirectorypath
        guard let path = folderPath else {
            return
        }

        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(categories)
        let dataPath = folderPath?.appendingPathComponent("stockStruct.json")
        FileManager.default.createFile(atPath: dataPath!.path, contents: data, attributes: nil)
    }

    func loadStockCompaniesStruct() -> [StockCompanies]{
        let documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
        var categories = [StockCompanies]()
        let folderPath = documentDirectorypath
        let dataPath = folderPath?.appendingPathComponent("stockStruct.json")
        if let newData = FileManager.default.contents(atPath: dataPath!.path) {
            categories = try! JSONDecoder().decode([StockCompanies].self, from: newData)
        }
        return categories
    }
}
