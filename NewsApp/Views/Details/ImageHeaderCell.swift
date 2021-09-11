//
//  ImageHeaderCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.09.2021.
//

import UIKit

class ImageHeaderCell: UICollectionViewCell {
    static let identifier = "ImageHeaderCell"

    var dataSource: Articles? {
        didSet {
            if let source = dataSource {
                sourceLabel.text = source.source.name.uppercased()
                if let image = source.urlToImage, source.urlToImage != "" {
                    headerImagView.sd_setImage(with: URL(string: image))
                } else {
                    headerImagView.image = UIImage(named: "news_image")
                }
            }
        }
    }

    let headerImagView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "news_image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()

    let sourceLabel: UILabel = {
        let label = UILabel()
        label.constrainHeight(constant: 50)
        label.font = UIFont(name: "ScopeOne-Regular", size: 25)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false

        let verticalStackView = UIStackView(arrangedSubviews: [
            sourceLabel,
            headerImagView
        ])
        verticalStackView.axis = .vertical

        addSubview(verticalStackView)
        verticalStackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
