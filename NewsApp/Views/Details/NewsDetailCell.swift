//
//  NewsDetailCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.09.2021.
//

import UIKit

class NewsDetailCell: UICollectionViewCell {
    static let identifier = "NewsDetailCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
