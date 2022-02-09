//
//  DeleteCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 09.02.2022.
//

import UIKit

class DeleteCell: UITableViewCell {
    let deleteLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.text = "Delete account"
        label.textAlignment = .left
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.constrainHeight(constant: 1)
        return view
    }()

    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus.circle")
        imageView.tintColor = .init(hex: 0xDB6400)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(accessoryImageView)
        accessoryImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 19, bottom: 0, right: 19), size: .init(width: 25, height: 25))
        accessoryImageView.centerYInSuperview()

        clipsToBounds = true
        addSubview(deleteLabel)
        deleteLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5, left: 15, bottom: 5, right: 15))

        deleteLabel.addSubview(bottomView)
        bottomView.anchor(top: nil, leading: deleteLabel.leadingAnchor, bottom: deleteLabel.bottomAnchor, trailing: deleteLabel.trailingAnchor)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
