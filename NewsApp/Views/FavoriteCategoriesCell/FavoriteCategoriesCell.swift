//
//  FavoriteCategoriesCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 29.09.2021.
//

import UIKit

class FavoriteCategoriesCell: BaseCell {

    static let identifier = "FavoriteCategoriesCell"

    var dataSourse: String? {
        didSet {
            if let text = dataSourse {
                categoryImageView.image = UIImage(named: text)
                categoryLabel.text = text
            }
        }
    }

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .left
        //        label.alpha = 0.5
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return label
    }()

    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.image = UIImage(named: "Sports")
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
        //        categoryImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 5, right: 5))

        //        addSubview(categoryLabel)
        //        categoryLabel.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
