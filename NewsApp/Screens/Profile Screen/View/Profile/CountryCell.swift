//
//  CountryCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 19.09.2021.
//

import UIKit

class CountryCell: UITableViewCell {
    let countryLabel = UILabel(textColor: .black)
    
    let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.constrainWidth(constant: 30)
        imageView.constrainHeight(constant: 30)
        return imageView
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.constrainHeight(constant: 1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView(arrangedSubviews: [
            countryImageView,
            countryLabel
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
