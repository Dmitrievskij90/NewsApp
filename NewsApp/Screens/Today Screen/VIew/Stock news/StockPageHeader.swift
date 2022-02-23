//
//  StockPageHeader.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 21.10.2021.
//

import UIKit

class StockPageHeader: UICollectionReusableView {
    let stockHeaderHorizontalController = StockHeaderHorizontalController()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stockHeaderHorizontalController.view)
        stockHeaderHorizontalController.view.fillSuperview()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
