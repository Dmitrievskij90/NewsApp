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
        label.textAlignment = .center
        //        label.alpha = 0.5
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.backgroundColor = UIColor(white: 1, alpha: 0.3)

        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 5
        label.layer.shadowOffset = .init(width: 0, height: 10)
        label.layer.shadowColor = UIColor.init(hex: 0xBE1FBB).cgColor
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

        addSubview(categoryImageView)
        categoryImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        addSubview(categoryLabel)
        categoryLabel.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
