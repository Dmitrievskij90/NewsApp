//
//  CategoriesCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 28.09.2021.
//

import UIKit

class CategoriesCell: BaseCell {
    var category: Categories? {
        didSet {
            if let currentCategory = category {
                let text = currentCategory.name
                let favorire = currentCategory.isFavorited
                categoryLabel.text = text
                starImageView.tintColor = favorire ? .init(hex: 0xF1A820) : .gray
                layer.shadowColor = favorire ? UIColor.init(hex: 0xDB6400).cgColor : UIColor.darkGray.cgColor
            }
        }
    }

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.constrainHeight(constant: 50)
        return label
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.constrainWidth(constant: 30)
        imageView.constrainHeight(constant: 30)
        return imageView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        backgroundColor = .white

        addSubview(categoryLabel)
        categoryLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))

        addSubview(starImageView)
        starImageView.centerInSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
