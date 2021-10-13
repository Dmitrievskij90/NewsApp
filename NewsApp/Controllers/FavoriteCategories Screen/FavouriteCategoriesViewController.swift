//
//  FavoriteCategoriesViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 29.09.2021.
//

import UIKit

class FavouriteCategoriesViewController: UIViewController {
    private var favouriteCategoriesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var set = Set<String>()
    private var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        set = CategoryManager.shared.loadCategoriesSet()
        categories = set.sorted()
        DispatchQueue.main.async {
            self.favouriteCategoriesCollectionView.reloadData()
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

        favouriteCategoriesCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        favouriteCategoriesCollectionView.register(FavoriteCategoriesCell.self, forCellWithReuseIdentifier: FavoriteCategoriesCell.identifier)
        favouriteCategoriesCollectionView.backgroundColor = UIColor.white
        favouriteCategoriesCollectionView.dataSource = self
        favouriteCategoriesCollectionView.delegate = self

        view.addSubview(favouriteCategoriesCollectionView)
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

        cell.layer.cornerRadius = 15
        cell.dataSourse = categories[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 24, left: 0, bottom: 24, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let res = categories[indexPath.item]
        let fullScreenController = FullScreenController()
        fullScreenController.modalPresentationStyle = .fullScreen
//        appDetailController.dataSource = res
        present(fullScreenController, animated: true, completion: nil)
//        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

