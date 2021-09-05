//
//  SearchCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import UIKit

class SearchCell: UICollectionViewCell {

    static let identifier = "SearchCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plant_image")
        imageView.constrainWidth(constant: 80)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()

    let autorLabel: UILabel = {
        let label = UILabel()
        label.text = "Autor"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "A Field Guide for Nature-Resistant Nerds"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        backgroundColor = UIColor(white: 0.9, alpha: 1)

        let verticalStackView = UIStackView(arrangedSubviews: [
            autorLabel,
            titleLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4

        let stackVIew = UIStackView(arrangedSubviews: [
            imageView,
            verticalStackView
        ])
        stackVIew.spacing = 8
        stackVIew.alignment = .center

        addSubview(stackVIew)
        stackVIew.fillSuperview()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
