//
//  CountryCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 19.09.2021.
//

import UIKit

class CountryCell: UITableViewCell {
    static let identifier = "CountryCell"

    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.constrainWidth(constant: 30)
        imageView.constrainHeight(constant: 30)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView(arrangedSubviews: [
            countryLabel,
            countryImageView
        ])
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.backgroundColor = .init(hex: 0xF1EFF1)
        stackView.layer.cornerRadius = 10

        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
