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

    //MARK: - User settings data manipulation methods
    //MARK: -
    func saveUserImage(image: UIImage) {
        guard let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            return
        }
        if FileManager.default.fileExists(atPath: documentsPath.path) == false {
            do {
                try FileManager.default.createDirectory(atPath: documentsPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Can't save image to directory")
            }
        }
        let data = image.jpegData(compressionQuality: 0.5)
        let imageName = "userImage.png"
        FileManager.default.createFile(atPath: "\(documentsPath.path)/\(imageName)", contents: data, attributes: nil)
    }

     func loadUserImage() -> UIImage? {
        var image = UIImage()
        guard let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            fatalError()
        }
        if let imageName = try? FileManager.default.contentsOfDirectory(atPath: "\(documentsPath.path)")[0] {
            if let loadedImage = UIImage(contentsOfFile: "\(documentsPath.path)/\(imageName)") {
                image = loadedImage
            }
        } else {
            image = UIImage(named: "avatar_image") ?? UIImage()
        }
        return image
    }

    func saveUser(with user: User) {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else { return }
        try? FileManager.default.createDirectory(at: documentDirectoryPath, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(user)
        let dataPath = documentDirectoryPath.appendingPathComponent("user.json")
        FileManager.default.createFile(atPath: dataPath.path, contents: data, attributes: nil)
    }

    func loadUser() -> User {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else { fatalError()}
        var user: User?
        let dataPath = documentDirectoryPath.appendingPathComponent("user.json")
        if let newData = FileManager.default.contents(atPath: dataPath.path) {
            user = try! JSONDecoder().decode(User.self, from: newData)
        }
        return user!
    }

    func isFirstLoad(_ loadCategories: () -> ()) {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            return
        }

        if FileManager.default.fileExists(atPath: documentsPath.path) == false {
            loadCategories()
        } else {
        }
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
