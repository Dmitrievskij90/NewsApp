//
//  SearchCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import UIKit

class SearchCell: BaseCell {

    static let identifier = "SearchCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plant_image")
        imageView.constrainWidth(constant: 80)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.image = UIImage(named: "news_image")
        return imageView
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Autor"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "A Field Guide for Nature-Resistant Nerds"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        backgroundColor = .white

        let verticalStackView = UIStackView(arrangedSubviews: [
            authorLabel,
            titleLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4

        let stackVIew = UIStackView(arrangedSubviews: [
            imageView,
            verticalStackView
        ])
        stackVIew.spacing = 16
        stackVIew.alignment = .center

        addSubview(stackVIew)
        stackVIew.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
