//
//  BaseCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.09.2021.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                    self.layer.shadowColor = UIColor.init(hex: 0xDB6400).cgColor
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    self.transform = .identity
                    self.backgroundColor = .white
                    self.layer.shadowColor = UIColor.darkGray.cgColor
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowColor = UIColor.darkGray.cgColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
