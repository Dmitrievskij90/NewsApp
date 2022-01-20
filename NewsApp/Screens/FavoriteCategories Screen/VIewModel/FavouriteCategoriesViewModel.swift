//
//  FavouriteCategoriesViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 16.12.2021.
//

import Foundation

class FavouriteCategoriesViewModel {
    var categories = CategoryManager.shared.loadCategoriesSet().sorted()
    
    func viewWillAppear() {
        categories = CategoryManager.shared.loadCategoriesSet().sorted()
    }
    
    func editViewModelForCategory(category: String) -> FullSceenCategoriesViewModel {
        return FullSceenCategoriesViewModel(category: category)
    }
}
