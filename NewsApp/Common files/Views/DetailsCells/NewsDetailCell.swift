//
//  NewsDetailCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.09.2021.
//

import UIKit

class NewsDetailCell: UICollectionViewCell {
    private let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black,
        .font: UIFont.systemFont(ofSize: 18)
    ]

    var dataSource: NewsCellModel? {
        didSet {
            if let source = dataSource {
                let attributedString = NSAttributedString(string: source.description, attributes: attributes)
                titleLabel.text = source.title
                descriptionTextView.attributedText = attributedString
                dateLabel.text = Helpers.shared.convertDate(date: source.publishedAt) 
            }
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel(font: .boldSystemFont(ofSize: 25), textColor: .black, numberOfLines: 0)
        label.constrainHeight(constant: 100)
        label.textAlignment = .center
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel(font: .systemFont(ofSize: 15), textColor: .lightGray)
        label.constrainHeight(constant: 30)
        label.centerXInSuperview()
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
