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
                    self.layer.shadowColor = UIColor.init(hex: 0xDB6400).cgColor
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
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowColor = UIColor.darkGray.cgColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height / 3
    }
}

extension BaseButton {
    func createGraphiteButton(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 20)
        setTitleColor(.init(hex: 0x4EFDD), for: .normal)
        backgroundColor = .init(hex: 0x494d4e)
        layer.borderColor = UIColor.lightGray.cgColor
    }

    func createWhiteButton(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 20)
        setTitleColor(.darkGray, for: .normal)
        backgroundColor = .white
        layer.borderColor = UIColor.init(hex: 0x4EFDD).cgColor
    }
}
