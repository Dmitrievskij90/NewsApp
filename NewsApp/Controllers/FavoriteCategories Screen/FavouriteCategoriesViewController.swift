//
//  FavoriteCategoriesViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 29.09.2021.
//

import UIKit

class FavouriteCategoriesViewController: UIViewController {
    private var categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var set = Set<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        set = CategoryManager.shared.loadCategoriesSet()

        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
        }
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black

        setupCollectinView()
    }

    private func setupCollectinView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        categoryCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        categoryCollectionView.register(FavoriteCategoriesCell.self, forCellWithReuseIdentifier: FavoriteCategoriesCell.identifier)
        categoryCollectionView.backgroundColor = UIColor.white
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        view.addSubview(categoryCollectionView)
    }
}

extension FavouriteCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return set.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCategoriesCell.identifier, for: indexPath) as? FavoriteCategoriesCell else {
            return UICollectionViewCell()
        }

        let text = set.sorted()

        cell.layer.cornerRadius = 15
        cell.categoryLabel.text = text[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width  - 30, height: (view.frame.width / 4) - 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
