//
//  NewsCategoryCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.10.2021.
//

import UIKit

class NewsCategoryCell: UITableViewCell {

    static let identifier = "NewsCategoryCell"

    var results: Articles? {
        didSet {
            if let source = results {
                authorLabel.text = source.source.name
                titleLabel.text = source.title
                if let image = source.urlToImage, source.urlToImage != "" {
                    newsImageView.sd_setImage(with: URL(string: image))
                } else {
                    newsImageView.image = UIImage(named: "news_image")
                }
            }
        }
    }

    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.constrainWidth(constant: 50)
        imageView.constrainHeight(constant: 50)
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white

        let verticalStackView = UIStackView(arrangedSubviews: [
            authorLabel,
            titleLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 0

        let stackVIew = UIStackView(arrangedSubviews: [
            newsImageView,
            verticalStackView
        ])
        stackVIew.spacing = 16
        stackVIew.alignment = .center

        addSubview(stackVIew)
        stackVIew.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
