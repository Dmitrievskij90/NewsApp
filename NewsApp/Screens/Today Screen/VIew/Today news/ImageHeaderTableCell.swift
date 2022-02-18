//
//  ImageHeaderTableCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.10.2021.
//

import UIKit

class ImageHeaderTableCell: UITableViewCell {
    var topConstaraint: NSLayoutConstraint?
    var dataSource: TodayCellModel? {
        didSet {
            if let source = dataSource {
                sourceLabel.text = source.source.uppercased()
                dateLabel.text = Helpers.shared.convertDate(date: source.date)
                titleLabel.text = source.title
                if source.image != "" {
                    newsImageView.sd_setImage(with: URL(string: source.image))
                } else {
                    newsImageView.image = UIImage(named: "news_image")
                }
            }
        }
    }

    private let sourceLabel: UILabel = {
        let label = UILabel(font: .boldSystemFont(ofSize: 20), textColor: .black)
        label.textAlignment = .center
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel(font: .systemFont(ofSize: 15), textColor: .lightGray)
        label.textAlignment = .center
        label.constrainHeight(constant: 15)
        return label
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.constrainHeight(constant: 200)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(font: .boldSystemFont(ofSize: 15), textColor: .black, numberOfLines: 0)
        label.textAlignment = .center
        label.constrainWidth(constant: 250)
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
