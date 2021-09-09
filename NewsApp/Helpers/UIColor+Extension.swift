//
//  UIColor+Extension.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 09.09.2021.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0x00FF00) >> 8
        let blue = hex & 0x0000FF

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
