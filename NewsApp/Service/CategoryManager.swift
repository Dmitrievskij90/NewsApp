//
//  CategoryManager.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 03.10.2021.
//

import UIKit

class CategoryManager {
    static let shared = CategoryManager()

    // MARK: - categories set data manipulation methods
    // MARK: -
    func saveCategoriesSet(with set: Set<String>) {
        saveSet(with: set, pathComponentName: "categoriesSet.json")
    }

    func loadCategoriesSet() -> Set<String> {
        loadSet(pathComponentName: "categoriesSet.json")
    }

    // MARK: - categories struct data manipulation methods
    // MARK: -
    func saveCategoriesStruct(with categories: [Categories]) {
        saveStruct(with: categories, pathComponentName: "categoriesStruct.json")
    }

    func loadCategoriesStruct() -> [Categories] {
        loadStruct(pathComponentName: "categoriesStruct.json")
    }

    // MARK: - stock companies set data manipulation methods
    // MARK: -
    func saveStockCompaniesSet(with set: Set<String>) {
        saveSet(with: set, pathComponentName: "stockSet.json")
    }

    func loadStockCompaniesSet() -> Set<String> {
        loadSet(pathComponentName: "stockSet.json")
    }

    // MARK: - stock companies struct data manipulation methods
    // MARK: -
    func saveStockCompaniesStruct(with categories: [StockCompanies]) {
        saveStruct(with: categories, pathComponentName: "stockStruct.json")
    }

    func loadStockCompaniesStruct() -> [StockCompanies] {
        loadStruct(pathComponentName: "stockStruct.json")
    }

    // MARK: - Сheck if this is the first app launch by the user
    // MARK: -
    func isFirstLoad(_ loadCategories: () -> Void) {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            return
        }
        if FileManager.default.fileExists(atPath: documentsPath.path) == false {
            loadCategories()
        }
    }

    // MARK: - Generic methods
    // MARK: -
    private func saveStruct<T: Codable>(with categories: [T], pathComponentName: String) {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            return
        }
        try? FileManager.default.createDirectory(at: documentDirectoryPath, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(categories)
        let dataPath = documentDirectoryPath.appendingPathComponent(pathComponentName)
        FileManager.default.createFile(atPath: dataPath.path, contents: data, attributes: nil)
    }

    private func loadStruct<T: Codable>(pathComponentName: String) -> [T] {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            fatalError("Can't find directory path")}
        var categories = [T]()
        let dataPath = documentDirectoryPath.appendingPathComponent(pathComponentName)
        if let newData = FileManager.default.contents(atPath: dataPath.path) {
            do {
                categories = try JSONDecoder().decode([T].self, from: newData)
            } catch {
                fatalError("Can't load Struct")
            }
        }
        return categories
    }

    private func loadSet<T: Codable>(pathComponentName: String) -> Set<T> {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            fatalError("Can't find directory path")}
        var set = Set<T>()
        let dataPath = documentDirectoryPath.appendingPathComponent(pathComponentName)
        if let newData = FileManager.default.contents(atPath: dataPath.path) {
            do {
                set = try JSONDecoder().decode(Set<T>.self, from: newData)
            } catch {
                fatalError("Can't load Set")
            }
        }
        return set
    }

    private func saveSet<T: Codable>(with set: Set<T>, pathComponentName: String) {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            return
        }
        try? FileManager.default.createDirectory(at: documentDirectoryPath, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(set)
        let dataPath = documentDirectoryPath.appendingPathComponent(pathComponentName)
        FileManager.default.createFile(atPath: dataPath.path, contents: data, attributes: nil)
    }
}
