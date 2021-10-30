//
//  StockHeaderHorizontalController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 21.10.2021.
//

import UIKit

class StockHeaderHorizontalController: UIViewController {
    var stockCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    var stockData = [StockData]()
    private var companyName = ""

    private var stockCompaniesSet = Set<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectinView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stockCompaniesSet = CategoryManager.shared.loadStockCompaniesSet()
        DispatchQueue.main.async {
            self.stockCollectionView.reloadData()
        }
    }

    private func setupCollectinView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        stockCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stockCollectionView.register(StockHeaderCell.self, forCellWithReuseIdentifier: StockHeaderCell.identifier)

        stockCollectionView.backgroundColor = UIColor.white
        stockCollectionView.dataSource = self
        stockCollectionView.delegate = self
        stockCollectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        stockCollectionView.showsHorizontalScrollIndicator = false

        view.addSubview(stockCollectionView)
        stockCollectionView.fillSuperview()
    }
}

extension StockHeaderHorizontalController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stockData.count

    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockHeaderCell.identifier, for: indexPath) as? StockHeaderCell else {
            return UICollectionViewCell()
        }

        let companyLabel = stockData[indexPath.item].symbol
        switch companyLabel {
                    case "AAPL" : companyName = "Apple"
                    case "AMZN" : companyName = "Amazon"
                    case "FB" : companyName = "Facebook"
                    case "GOGL" : companyName = "Google"
                    case "IBM" : companyName = "IBM"
                    case "INTC" : companyName = "Intel"
                    case "KO" : companyName = "Coca-Cola"
                    case "MCD" : companyName = "McDonald’s"
                    case "MSFT" : companyName = "Microsoft"
                    case "NFLX" : companyName = "Netflix"
                    case "NKE" : companyName = "Nike"
                    case "PEP" : companyName = "Pepsi"
                    case "SBUX" : companyName = "Starbucks"
                    case "TSLA" : companyName = "Tesla"
                    case "V" : companyName = "Visa"
                    default: break
        }

        cell.logoLabel.text = companyName
        cell.logoImageView.image = UIImage(named:stockData[indexPath.item].symbol)
        cell.priceLabel.text = String(stockData[indexPath.item].price) + "$"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width / 3, height: view.frame.height)
    }
}
