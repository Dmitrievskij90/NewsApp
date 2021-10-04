//
//  ProfileTableFooter.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.09.2021.
//

import UIKit

class ProfileTableFooter: UIView {

    var transitionHandler: (()->())? = nil

    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.constrainHeight(constant: 1)
        return view
    }()

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Favourite categories", for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = .init(hex: 0xBE1FBB)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        clipsToBounds = true

        addSubview(accessoryImageView)
        accessoryImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 19, bottom: 0, right: 19) ,size: .init(width: 25, height: 25))
        accessoryImageView.centerYInSuperview()

        addSubview(button)
        button.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 19, bottom: 0, right: 19))

        addSubview(bottomView)
        bottomView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonPressed() {
        transitionHandler?()
    }
}
