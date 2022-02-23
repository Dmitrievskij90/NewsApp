//
//  CloseButton.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.02.2022.
//

import UIKit

class CloseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        tintColor = .init(hex: 0xDB6400)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
