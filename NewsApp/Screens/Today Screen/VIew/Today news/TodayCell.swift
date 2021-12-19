//
//  TodayCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 11.09.2021.
//

import UIKit

class TodayCell: BaseCell {
    private var topConstaraint: NSLayoutConstraint?

    var results: TodayCellModel? {
        didSet {
            if let source = results {
                sourceLabel.text = source.source.uppercased()
                dateLabel.text = Helpers.shared.convertDate(date: source.date)
                titleLabel.text = source.title
                if source.image != "" {
                    imageView.sd_setImage(with: URL(string: source.image))
                } else {
                    imageView.image = UIImage(named: "news_image")
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
    
    private let dateLabel: UILabel = {
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.constrainHeight(constant: 200)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.constrainWidth(constant: 250)
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
        topVerticalStackView.axis = .vertical
        topVerticalStackView.alignment = .center
        topVerticalStackView.spacing = 10
        topVerticalStackView.constrainHeight(constant: 40)
        
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            topVerticalStackView,
            imageView,
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
