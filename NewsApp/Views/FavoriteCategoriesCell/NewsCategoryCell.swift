//
//  NewsCategoryCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.10.2021.
//

import UIKit

class NewsCategoryCell: UITableViewCell {

    static let identifier = "NewsCategoryCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
