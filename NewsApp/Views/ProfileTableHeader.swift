//
//  ProfileTableHeader.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 24.09.2021.
//

import UIKit

class ProfileTableHeader: UITableViewHeaderFooterView {

    static let identifier = "ProfileTableHeader"

    let countryLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(countryLabel)
        countryLabel.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
