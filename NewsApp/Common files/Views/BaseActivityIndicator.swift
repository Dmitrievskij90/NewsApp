//
//  BaseActivityIndicator.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 13.12.2021.
//

import UIKit

class BaseActivityIndicator: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        color = .darkGray
        hidesWhenStopped = true
        startAnimating()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
