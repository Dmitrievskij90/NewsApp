//
//  StockHeaderCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 21.10.2021.
//

import UIKit

class StockHeaderCell: UICollectionViewCell {
    static let identifier = "StockHeaderCell"

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
//        imageView.image = UIImage(named: "visa")
        imageView.constrainWidth(constant: 40)
        imageView.constrainHeight(constant: 40)
        imageView.backgroundColor = .clear
        return imageView
    }()

    let logoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .center
//        label.text = "McDonald’s"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
//        label.backgroundColor = .red
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "238.24$"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
//        label.backgroundColor = .green
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor

        let labelsStackView = UIStackView(arrangedSubviews: [logoLabel, priceLabel])
        labelsStackView.axis = .vertical


        let stackView = UIStackView(arrangedSubviews: [logoImageView, labelsStackView])

        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        stackView.layer.shadowOpacity = 0.6
        stackView.layer.shadowRadius = 10
        stackView.layer.shadowOffset = .init(width: 0, height: 20)
        stackView.layer.shadowColor = UIColor.darkGray.cgColor



    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
