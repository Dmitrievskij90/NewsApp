//
//  StockHeaderCell.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 21.10.2021.
//

import UIKit

class StockHeaderCell: UICollectionViewCell {
    private var companyName = ""
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                    self.layer.shadowColor = UIColor.init(hex: 0xDB6400).cgColor
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    self.transform = .identity
                    self.backgroundColor = .white
                    self.layer.shadowColor = UIColor.darkGray.cgColor
                }
            }
        }
    }
    
    var data: StockHeaderCellModel? {
        didSet {
            if let stockData = data {
                switch stockData.symbol {
                case "AAPL" :
                    companyName = "Apple"
                case "AMZN" :
                    companyName = "Amazon"
                case "FB" :
                    companyName = "Facebook"
                case "GOGL" :
                    companyName = "Google"
                case "IBM" :
                    companyName = "IBM"
                case "INTC" :
                    companyName = "Intel"
                case "KO" :
                    companyName = "Coca-Cola"
                case "MCD" :
                    companyName = "McDonald’s"
                case "MSFT" :
                    companyName = "Microsoft"
                case "NFLX" :
                    companyName = "Netflix"
                case "NKE" :
                    companyName = "Nike"
                case "PEP" :
                    companyName = "Pepsi"
                case "SBUX" :
                    companyName = "Starbucks"
                case "TSLA" :
                    companyName = "Tesla"
                case "V" :
                    companyName = "Visa"
                default:
                    break
                }
                logoLabel.text = companyName
                logoImageView.image = UIImage(named: stockData.symbol)
                priceLabel.text = String(format: "%.2f", stockData.price) + "$"
            }
        }
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.constrainWidth(constant: 40)
        imageView.constrainHeight(constant: 40)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        let labelsStackView = UIStackView(arrangedSubviews: [logoLabel, priceLabel])
        labelsStackView.axis = .vertical

        let stackView = UIStackView(arrangedSubviews: [logoImageView, labelsStackView])
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        stackView.layer.shadowOpacity = 0.6
        stackView.layer.shadowRadius = 10
        stackView.layer.shadowOffset = .init(width: 0, height: 10)
        stackView.layer.shadowColor = UIColor.darkGray.cgColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
