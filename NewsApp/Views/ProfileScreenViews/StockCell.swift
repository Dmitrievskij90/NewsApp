//
//  StockCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.10.2021.
//

import UIKit

class StockCell: UITableViewCell {
    static let identifier = "StockCell"
    var company: StockCompanies? {
        didSet {
            if let currentCompany = company {
                let isFavorited = currentCompany.isFavorited
                stockImageView.image = UIImage(named: currentCompany.symbol)
                stockLabel.text = currentCompany.name
                accessoryType = isFavorited ? .checkmark : .none
            }
        }
    }

   private  let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

   private let stockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.constrainWidth(constant: 30)
        imageView.constrainHeight(constant: 30)
        return imageView
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
            stockLabel
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
