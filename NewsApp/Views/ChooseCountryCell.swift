//
//  ChooseCountryCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 21.09.2021.
//

import UIKit

class ChooseCountryCell: UITableViewCell {
    static let identifier = "ChooseCountryCell"

    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "Choose country for top headlines"
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        backgroundColor = .init(hex: 0xBE1FBB)
        layer.cornerRadius = 16
        clipsToBounds = true
        addSubview(countryLabel)
        countryLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 5, left: 15, bottom: 5, right: 15))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
