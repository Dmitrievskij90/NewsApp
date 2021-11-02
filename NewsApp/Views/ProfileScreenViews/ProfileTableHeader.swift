//
//  ProfileTableHeader.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 24.09.2021.
//

import UIKit

class ProfileTableHeader: UIView {

    static let identifier = "ProfileTableHeader"
    private let countryImageName = UserDefaults.standard.value(forKey: "countryImage") as? String ?? "usa_image"

    var imageTapHandler: (() ->())? = nil

    let bcgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x16697A)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.init(hex: 0xDB6400).cgColor
//        view.alpha = 0.5
        return view
    }()

    let helloLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.constrainHeight(constant: 100)
        return label
    }()

    let countrylabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 1
        label.text = "Country for top headlines:"
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.constrainHeight(constant: 50)
        imageView.constrainWidth(constant: 50)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.init(hex: 0xDB6400).cgColor
        imageView.image = UIImage(named: "news_image")
        imageView.constrainHeight(constant: 100)
        imageView.constrainWidth(constant: 100)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bcgView)
        bcgView.fillSuperview()

        addSubview(profileView)
        profileView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))


        let verticalStackVIew = UIStackView(arrangedSubviews: [
            helloLabel,
            countrylabel,
            countryImageView
        ])
        verticalStackVIew.axis = .vertical
        verticalStackVIew.spacing = 6
        verticalStackVIew.alignment = .leading

        addSubview(userImageView)
        userImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 20))

        addSubview(verticalStackVIew)
        verticalStackVIew.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: userImageView.leadingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 0))

        let tapGestureregognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        userImageView.addGestureRecognizer(tapGestureregognizer)

        countryImageView.image = UIImage(named: countryImageName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func imageViewTapped() {
        imageTapHandler?()
    }
}
