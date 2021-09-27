//
//  ProfileTableHeader.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 24.09.2021.
//

import UIKit

class ProfileTableHeader: UITableViewHeaderFooterView {

    static let identifier = "ProfileTableHeader"
    private let countryImageName = UserDefaults.standard.value(forKey: "countryImage") as? String ?? "usa_image"

    var imageTapHandler: (() ->())?

    let bcgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xBE1FBB)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.alpha = 0.5
        return view
    }()

    let helloLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
        label.textColor = .black
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
        imageView.constrainHeight(constant: 40)
        imageView.constrainWidth(constant: 50)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(named: "news_image")
        imageView.constrainHeight(constant: 100)
        imageView.constrainWidth(constant: 100)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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

        let stackVIew = UIStackView(arrangedSubviews: [
            verticalStackVIew,
            userImageView
        ])
        stackVIew.spacing = 16
        stackVIew.alignment = .center

        addSubview(stackVIew)
        stackVIew.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))

        let tapGestureregognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        userImageView.addGestureRecognizer(tapGestureregognizer)

        countryImageView.image = UIImage(named: countryImageName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func imageViewTapped() {
        imageTapHandler!()
    }
}
