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
                    headerImageView.sd_setImage(with: URL(string: image))
                } else {
                    headerImageView.image = UIImage(named: "news_image")
                }
            }
        }
    }

    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "news_image")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.constrainHeight(constant: 50)
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        clipsToBounds = true

        let verticalStackView = UIStackView(arrangedSubviews: [
            sourceLabel,
            headerImageView
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
