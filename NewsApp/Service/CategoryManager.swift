//
//  CategoryManager.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 03.10.2021.
//

import UIKit

class CategoryManager {
    static let shared = CategoryManager()

    //MARK: - categories set data manipulation methods
    //MARK: -
    func saveCategoriesSet(with set: Set<String>) {
        saveSet(with: set, pathComponentName: "categoriesSet.json")
    }

    func loadCategoriesSet() -> Set<String>{
        loadSet(pathComponentName: "categoriesSet.json")
    }

    //MARK: - categories struct data manipulation methods
    //MARK: -
    func saveCategoriesStruct(with categories: [Categories]) {
        saveStruct(with: categories, pathComponentName: "categoriesStruct.json")
    }

    func loadCategoriesStruct() -> [Categories]{
        loadStruct(pathComponentName: "categoriesStruct.json")
    }

    //MARK: - stock companies set data manipulation methods
    //MARK: -
    func saveStockCompaniesSet(with set: Set<String>) {
        saveSet(with: set, pathComponentName: "stockSet.json")

    }

    func loadStockCompaniesSet() -> Set<String>{
        loadSet(pathComponentName: "stockSet.json")
    }

    //MARK: - stock companies struct data manipulation methods
    //MARK: -
    func saveStockCompaniesStruct(with categories: [StockCompanies]) {
        saveStruct(with: categories, pathComponentName: "stockStruct.json")
    }

    func loadStockCompaniesStruct() -> [StockCompanies]{
        loadStruct(pathComponentName: "stockStruct.json")
    }

    //MARK: - Generic methods
    //MARK: -
    func saveStruct<T:Codable>(with categories: [T], pathComponentName: String) {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else { return }
        try? FileManager.default.createDirectory(at: documentDirectoryPath, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(categories)
        let dataPath = documentDirectoryPath.appendingPathComponent(pathComponentName)
        FileManager.default.createFile(atPath: dataPath.path, contents: data, attributes: nil)
    }

    func loadStruct<T: Codable>(pathComponentName: String) -> [T] {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else { fatalError()}
        var categories = [T]()
        let dataPath = documentDirectoryPath.appendingPathComponent(pathComponentName)
        if let newData = FileManager.default.contents(atPath: dataPath.path) {
            categories = try! JSONDecoder().decode([T].self, from: newData)
        }
        return categories
    }

    func loadSet<T: Codable>(pathComponentName: String) -> Set<T> {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else { fatalError()}
        var categories = Set<T>()
        let dataPath = documentDirectoryPath.appendingPathComponent(pathComponentName)
        if let newData = FileManager.default.contents(atPath: dataPath.path) {
            categories = try! JSONDecoder().decode(Set<T>.self, from: newData)
        }
        return categories
    }

    func saveSet<T:Codable>(with categories: Set<T>, pathComponentName: String) {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else { return }
        try? FileManager.default.createDirectory(at: documentDirectoryPath, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(categories)
        let dataPath = documentDirectoryPath.appendingPathComponent(pathComponentName)
        FileManager.default.createFile(atPath: dataPath.path, contents: data, attributes: nil)
    }
}
