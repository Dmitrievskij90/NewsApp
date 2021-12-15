//
//  NewsDetailTableCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.10.2021.
//

import UIKit

class NewsDetailTableCell: UITableViewCell {
    private let paragraph = NSMutableParagraphStyle()
    private var attributes = [NSAttributedString.Key : Any]()
    
    var dataSource: TodayCellModel? {
        didSet {
            if let source = dataSource {
                let attributedString = NSAttributedString(string: source.description , attributes: attributes)
                descriptionTextView.attributedText = attributedString
            }
        }
    }

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        paragraph.alignment = .justified
        attributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 19),
            .paragraphStyle : paragraph
        ]

        addSubview(descriptionTextView)
        descriptionTextView.fillSuperview(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

