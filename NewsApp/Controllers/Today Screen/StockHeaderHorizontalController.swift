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
        cell.data = stockData[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width / 3, height: view.frame.height)
    }
}
