//
//  ProfileTableFooter.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.09.2021.
//

import UIKit

class ProfileTableFooter: UIView {
    var transitionHandler: (() -> Void)?

    private let logOutButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.createGraphiteButton(title: "LOG OUT")
        button.constrainHeight(constant: 50)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        clipsToBounds = true

        addSubview(logOutButton)
        logOutButton.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 50, bottom: 50, right: 50), size: .init(width: 0, height: DefaultParameters.buttonHeight))
        logOutButton.centerInSuperview()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonPressed() {
        transitionHandler?()
    }
}
