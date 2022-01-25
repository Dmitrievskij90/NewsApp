//
//  CategoriesViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 17.01.2022.
//

import Foundation

class CategoriesViewModel {
    var categoriesStruct = [Categories]()
    private var categoriesSet = Set<String>()

    init() {
        addObserver()
    }

    func viewWillAppear() {
        categoriesSet = CategoryManager.shared.loadCategoriesSet()
        categoriesStruct = CategoryManager.shared.loadCategoriesStruct()
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.saveCategoriesByIndexPath),
            name: Notification.Name("indexPath"),
            object: nil)
    }

    @objc private func saveCategoriesByIndexPath(_ notification: Notification) {
        if let path = notification.object {
            guard let indexPasth = path as? IndexPath else {
                return
            }
            didSelectItem(indexPath: indexPasth)
        }
    }

    private func didSelectItem(indexPath: IndexPath) {
        let name = categoriesStruct[indexPath.item]
        let hasFavorited = name.isFavorited
        categoriesStruct[indexPath.item].isFavorited = !hasFavorited
        CategoryManager.shared.saveCategoriesStruct(with: categoriesStruct)

        let item = categoriesStruct[indexPath.item].name
        if categoriesSet.contains(item) {
            categoriesSet.remove(item)
            CategoryManager.shared.saveCategoriesSet(with: categoriesSet)
        } else {
            categoriesSet.insert(item)
            CategoryManager.shared.saveCategoriesSet(with: categoriesSet)
        }
    }
}
