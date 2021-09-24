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
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.constrainWidth(constant: 50)
        imageView.constrainHeight(constant: 50)
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

        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
