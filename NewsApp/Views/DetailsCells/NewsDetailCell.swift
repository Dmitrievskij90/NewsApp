//
//  NewsDetailCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.09.2021.
//

import UIKit

class NewsDetailCell: UICollectionViewCell {
    static let identifier = "NewsDetailCell"
    private let attributes: [NSAttributedString.Key : Any] = [
        .foregroundColor : UIColor.black,
        .font : UIFont.systemFont(ofSize: 18)
    ]

    var dataSource: Articles? {
        didSet {
            if let source = dataSource {
                let attributedString = NSAttributedString(string: source.description ?? "", attributes: attributes)
                titleLabel.text = source.title
                descriptionTextView.attributedText = attributedString
                dateLabel.text = Helpers.shared.convertDate(date: source.publishedAt) 
            }
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.constrainHeight(constant: 100)
        label.font = .boldSystemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.constrainHeight(constant: 30)
        label.centerXInSuperview()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 18)
        textView.textColor = .darkGray
        textView.textAlignment = .justified
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        let verticalStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            dateLabel,
            descriptionTextView
        ])
        verticalStackView.axis = .vertical

        addSubview(verticalStackView)
        verticalStackView.fillSuperview(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
