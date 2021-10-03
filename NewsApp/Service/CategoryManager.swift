//
//  CategoryManager.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 03.10.2021.
//

import UIKit

class CategoryManager {

    static let shared = CategoryManager()

    var documentDirectorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent("New test folder")

    func saveCategories(with set: Set<String>) {
        let folderPath = documentDirectorypath
        guard let pass = folderPath else {
            return
        }
        print(pass)

        try? FileManager.default.createDirectory(at: pass, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(set)
        let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
        FileManager.default.createFile(atPath: dataPath!.path, contents: data, attributes: nil)
        
    }

    func loadCategoriesSet() -> Set<String>{
        var categorySet = Set<String>()
        let folderPath = documentDirectorypath
        let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
        if let newData = FileManager.default.contents(atPath: dataPath!.path) {
            categorySet = try! JSONDecoder().decode(Set<String>.self, from: newData)
        }
        return categorySet
    }
}
