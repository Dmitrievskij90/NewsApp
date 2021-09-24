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
        label.textColor = .black
        label.text = "Choose country for top headlines"
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.constrainHeight(constant: 1)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        layer.cornerRadius = 16
        clipsToBounds = true
        addSubview(countryLabel)
        countryLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 5, left: 15, bottom: 5, right: 15))

        countryLabel.addSubview(bottomView)
        bottomView.anchor(top: nil, leading: countryLabel.leadingAnchor, bottom: countryLabel.bottomAnchor, trailing: countryLabel.trailingAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
