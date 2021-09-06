//
//  ImageHeaderCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.09.2021.
//

import UIKit

class ImageHeaderCell: UICollectionViewCell {
    static let identifier = "ImageHeaderCell"

    let headerImagView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "news_image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false

        backgroundColor = .blue

        addSubview(headerImagView)
        headerImagView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }


    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
