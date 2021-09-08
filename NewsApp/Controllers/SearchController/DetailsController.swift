//
//  DetailsController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.09.2021.
//

import UIKit

class DetailsController: UIViewController {

    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())

    var dataSource: Articles?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        setupCollectinView()
    }

    private func setupCollectinView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(ImageHeaderCell.self, forCellWithReuseIdentifier: ImageHeaderCell.identifier)
        collectionView.register(NewsDetailCell.self, forCellWithReuseIdentifier: NewsDetailCell.identifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
}

extension DetailsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageHeaderCell.identifier, for: indexPath) as? ImageHeaderCell else {
                return UICollectionViewCell()
            }
            cell.dataSource = self.dataSource
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailCell.identifier, for: indexPath) as? NewsDetailCell else {
            return UICollectionViewCell()
        }
        cell.dataSource = self.dataSource
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return.init(width: view.frame.width, height: view.frame.height / 3)
        }
        return .init(width: view.frame.width, height: view.frame.height / 2)
    }


}

