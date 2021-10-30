//
//  StockCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.10.2021.
//

import UIKit

class StockCell: UITableViewCell {

    static let identifier = "StockCell"

    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let stockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.constrainWidth(constant: 30)
        imageView.constrainHeight(constant: 30)
        return imageView
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .right
//        label.text = "238.24$"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.constrainHeight(constant: 1)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tintColor = .label

        let stackView = UIStackView(arrangedSubviews: [
            stockImageView,
            stockLabel,
            priceLabel
        ])
        stackView.alignment = .center
        stackView.spacing = 5

        let vStackView = UIStackView(arrangedSubviews: [
           stackView,
            bottomView
        ])
        vStackView.axis = .vertical

        addSubview(vStackView)
        vStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5, left: 15, bottom: 5, right: 15))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
