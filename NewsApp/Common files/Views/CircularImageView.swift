//
//  CircularImageView.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.11.2021.
//

import UIKit

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
