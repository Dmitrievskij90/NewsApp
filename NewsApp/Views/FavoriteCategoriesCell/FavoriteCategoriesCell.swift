//
//  FavoriteCategoriesCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 29.09.2021.
//

import UIKit

class FavoriteCategoriesCell: BaseCell {

    static let identifier = "FavoriteCategoriesCell"

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        backgroundColor = .white

        addSubview(categoryLabel)
        categoryLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))

        addSubview(categoryImageView)
        categoryImageView.anchor(top: categoryLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 5, right: 5))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
