//
//  FloatingContainerView.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 09.09.2021.
//

import UIKit

class FloatingContainerView: UIView {
    var transitionHandler: (() -> Void)?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.constrainWidth(constant: 80)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let label: UILabel = {
        let text = "Do you want more information?"
        let label = UILabel(text: text, textColor: .black, numberOfLines: 2)
        label.textAlignment = .center
        return label
    }()
    
    private let goButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.setTitleColor(.init(hex: 0x4EFDD), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("GO", for: .normal)
        button.contentMode = .center
        button.backgroundColor = .init(hex: 0x494d4e)
        button.constrainWidth(constant: 90)
        button.constrainHeight(constant: 40)
        button.addTarget(self, action: #selector(goToWebController), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = .init(hex: 0xE6E6E6)
        
        let stackVIew = UIStackView(arrangedSubviews: [
            imageView,
            label,
            goButton
        ])
        stackVIew.spacing = 16
        stackVIew.alignment = .center
        
        addSubview(stackVIew)
        stackVIew.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func goToWebController() {
        transitionHandler?()
    }
}
