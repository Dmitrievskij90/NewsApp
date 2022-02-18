//
//  UILabel+Extension.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.12.2021.
//

import UIKit

extension UILabel {
    convenience init(text: String = "", font: UIFont = .boldSystemFont(ofSize: 18), textColor: UIColor = .darkGray, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
        self.textAlignment = .left
        self.textColor = textColor
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
}
