//
//  StockHeaderCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 21.10.2021.
//

import UIKit

class StockHeaderCell: UICollectionViewCell {
    static let identifier = "StockHeaderCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        layer.cornerRadius = 10


    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
