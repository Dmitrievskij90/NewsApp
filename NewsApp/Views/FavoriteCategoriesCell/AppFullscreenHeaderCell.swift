//
//  AppFullscreenHeaderCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 07.10.2021.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {

    let favoriteCell = FavoriteCategoriesCell()
    static let identifier = "AppFullscreenHeaderCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(favoriteCell)
        favoriteCell.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
