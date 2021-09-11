//
//  TodayCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 11.09.2021.
//

import UIKit

class TodayCell: BaseCell {
    static let identifier = "TodayCell"
    private var topConstaraint: NSLayoutConstraint?

    private let sourceLabel: UILabel = {
        let label = UILabel()
//        label.constrainHeight(constant: 50)
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "BBC"
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "8 September 2021"
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "news_image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.centerInSuperview(size: .init(width: 240, height: 240))
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Владимир Путин об Олимпиаде: «Не могу не вспомнить далекие от спорта политизированные решения в отношении наше - Sports.ru"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        backgroundColor = .white

        let topVerticalStackView = UIStackView(arrangedSubviews: [
            sourceLabel,
            dateLabel
        ])
        topVerticalStackView.axis = .horizontal
        topVerticalStackView.alignment = .center
        topVerticalStackView.spacing = 10


        let verticalStackView = UIStackView(arrangedSubviews: [
           topVerticalStackView,
            imageView,
            titleLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.spacing = 5

        addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 24, left: 24, bottom: 24, right: 24))
        self.topConstaraint = verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstaraint?.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
