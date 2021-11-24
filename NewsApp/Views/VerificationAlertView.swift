//
//  VerificationAlertView.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 08.11.2021.
//

import UIKit

class VerificationAlertView: UIView {
    var tapHandler: (()->())?

    private let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "Virify you account.\nWe sent verification email to you. Please verify and tap Let's go button again"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        return label
    }()

    let virificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "virification_image")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.tintColor = .init(hex: 0x4EFDD)
        return imageView
    }()

    private let oKButton: UIButton = {
        let button = BaseButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.init(hex: 0x494d4e), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(oKButonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(hex: 0x494d4e)
        layer.cornerRadius = 15
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowColor = UIColor.darkGray.cgColor

        let stackView = UIStackView(arrangedSubviews: [alertLabel,virificationImageView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally

        addSubview(oKButton)
        oKButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 25, bottom: 25, right: 25), size: .init(width: 0, height: 50))

        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: oKButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 25, left: 25, bottom: 25, right: 25))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func oKButonPressed() {
        tapHandler?()
    }
}
