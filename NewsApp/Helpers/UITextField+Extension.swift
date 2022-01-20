//
//  UITextField+Extension.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.12.2021.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String, constrainHeight: CGFloat = DefaultParameters.buttonHeight) {
        self.init(frame: .zero)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font : UIFont.systemFont(ofSize: 10)
        ]
        let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
        self.attributedPlaceholder = attributedString
        self.borderStyle = .roundedRect
        self.font = .systemFont(ofSize: 18)
        self.backgroundColor = .white
        self.textAlignment = .center
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = .init(width: 0, height: 10)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.constrainHeight(constant: constrainHeight)
    }
}
