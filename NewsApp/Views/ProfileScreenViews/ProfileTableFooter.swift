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
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("LOG OUT", for: .normal)
        button.backgroundColor = .init(hex: 0x16697A)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.constrainWidth(constant: 100)
        button.constrainHeight(constant: 50)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        clipsToBounds = true

        addSubview(logOutButton)
        logOutButton.centerInSuperview()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonPressed() {
        transitionHandler?()
    }
}
