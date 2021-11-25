//
//  ImageHeaderTableCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.10.2021.
//

import UIKit

class ImageHeaderTableCell: UITableViewCell {

    static let identifier = "ImageHeaderTableCell"

     var topConstaraint: NSLayoutConstraint?
    var dataSource: Articles? {
        didSet {
            if let source = dataSource {
                sourceLabel.text = source.source.name.uppercased()
                dateLabel.text = Helpers.shared.convertDate(date: source.publishedAt)
                titleLabel.text = source.title
                if let image = source.urlToImage, source.urlToImage != "" {
                    newsImageView.sd_setImage(with: URL(string: image))
                } else {
                    newsImageView.image = UIImage(named: "news_image")
                }
            }
        }
    }

    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "BBC"
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.constrainHeight(constant: 15)
        label.text = "8 September 2021"
        return label
    }()

    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.constrainHeight(constant: 200)
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.constrainWidth(constant: 250)
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true

        layer.cornerRadius = 16
        backgroundColor = .white

        let topVerticalStackView = UIStackView(arrangedSubviews: [
            sourceLabel,
            dateLabel
        ])
        topVerticalStackView.axis = .vertical
        topVerticalStackView.alignment = .center
        topVerticalStackView.spacing = 10
        topVerticalStackView.constrainHeight(constant: 40)


        let verticalStackView = UIStackView(arrangedSubviews: [
           topVerticalStackView,
            newsImageView,
            titleLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.spacing = 5

        addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 24, bottom: 10, right: 24))
        self.topConstaraint = verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstaraint?.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

