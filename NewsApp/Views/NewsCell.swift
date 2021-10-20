//
//  NewsCategoryCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.10.2021.
//

import UIKit

class NewsCell: UICollectionViewCell {

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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
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
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    let separatorView: UIView = {
        let view =  UIView()
        view.backgroundColor =  UIColor(white: 0, alpha: 0.3)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        newsImageView.constrainWidth(constant: 64)
        newsImageView.constrainHeight(constant: 64)

        let labelsStackView = UIStackView(arrangedSubviews: [authorLabel, titleLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 1

        let stackView = UIStackView(arrangedSubviews: [newsImageView, labelsStackView])
        stackView.spacing = 16
        stackView.alignment = .center

        addSubview(stackView)
        stackView.fillSuperview()

        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: authorLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
