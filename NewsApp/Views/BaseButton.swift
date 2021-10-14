//
//  BaseButton.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.10.2021.
//

import UIKit

class BaseButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                    self.layer.shadowColor = UIColor.purple.cgColor
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    self.transform = .identity
                    self.layer.shadowColor = UIColor.darkGray.cgColor
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentMode = .center
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 16

        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowColor = UIColor.darkGray.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
