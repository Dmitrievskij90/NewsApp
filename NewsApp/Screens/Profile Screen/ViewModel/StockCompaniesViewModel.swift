//
//  StockCompaniesViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 17.01.2022.
//

import Foundation

class StockCompaniesViewModel {
    var stockCompaniesStruct = [StockCompanies]()
    private var stockCompaniesSet = Set<String>()

    init() {
        addObserver()
        NotificationCenter.default.post(name: NSNotification.Name("stockCompaniesSet"), object: stockCompaniesSet)
    }

     func viewWillAppear() {
        stockCompaniesSet = CategoryManager.shared.loadStockCompaniesSet()
        stockCompaniesStruct =  CategoryManager.shared.loadStockCompaniesStruct()
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.saveStockCompaniesByIndexPath),
            name: Notification.Name("stockIndexPath"),
            object: nil)
    }

    @objc private func saveStockCompaniesByIndexPath(_ notification: Notification) {
        if let path = notification.object {
            guard let indexPasth = path as? IndexPath else {return}
            didSelectItem(indexPath: indexPasth)
        }
    }

    private func didSelectItem(indexPath: IndexPath) {
        let hasFavorited = stockCompaniesStruct[indexPath.item].isFavorited
        stockCompaniesStruct[indexPath.item].isFavorited = !hasFavorited
        CategoryManager.shared.saveStockCompaniesStruct(with: stockCompaniesStruct)

        let name = stockCompaniesStruct[indexPath.row].symbol
        if stockCompaniesSet.contains(name) {
            stockCompaniesSet.remove(name)
            CategoryManager.shared.saveStockCompaniesSet(with: stockCompaniesSet)
        } else {
            stockCompaniesSet.insert(name)
            CategoryManager.shared.saveStockCompaniesSet(with: stockCompaniesSet)
        }
    }
}
