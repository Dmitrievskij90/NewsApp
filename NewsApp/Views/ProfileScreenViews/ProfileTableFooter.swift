//
//  ProfileTableFooter.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.09.2021.
//

import UIKit

class ProfileTableFooter: UIView {

    var transitionHandler: (()->())? = nil

    private let logOutButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(.init(hex: 0x4EFDD), for: .normal)
        button.backgroundColor = .init(hex: 0x494d4e)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.constrainHeight(constant: 50)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        clipsToBounds = true

        addSubview(logOutButton)
        logOutButton.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 50, bottom: 50, right: 50), size: .init(width: 0, height: 50))
        logOutButton.centerInSuperview()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonPressed() {
        transitionHandler?()
    }
}
