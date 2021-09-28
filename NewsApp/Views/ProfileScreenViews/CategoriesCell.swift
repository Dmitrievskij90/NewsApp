//
//  CategoriesCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 28.09.2021.
//

import UIKit

class CategoriesCell: BaseCell {

    static let identifier = "CategoriesCell"

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        backgroundColor = .white

        addSubview(categoryLabel)
        categoryLabel.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
