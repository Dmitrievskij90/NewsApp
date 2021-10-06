//
//  CategoriesViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 28.09.2021.
//

import UIKit

class CategoriesViewController: UIViewController {
    private var categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var categoriesSet = Set<String>()
    private var categoriesStruct = [Categories]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        categoriesSet = CategoryManager.shared.loadCategoriesSet()
        categoriesStruct = CategoryManager.shared.loadCategoriesStruct()
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
        categoryCollectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: CategoriesCell.identifier)
        categoryCollectionView.backgroundColor = UIColor.white
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        view.addSubview(categoryCollectionView)
        categoryCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesStruct.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCell.identifier, for: indexPath) as? CategoriesCell else {
            return UICollectionViewCell()
        }

        let text = categoriesStruct[indexPath.item].name
        let favorire = categoriesStruct[indexPath.item].isFavorited

        cell.layer.cornerRadius = 15
        cell.categoryLabel.text = text
        cell.layer.shadowColor = favorire ? UIColor.purple.cgColor : UIColor.darkGray.cgColor
        cell.starImageView.tintColor = favorire ? .init(hex: 0xF1A820) : .gray

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 20, height: (view.frame.width / 2) - 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = categoriesStruct[indexPath.item]
        let hasFavorited = name.isFavorited
        categoriesStruct[indexPath.item].isFavorited = !hasFavorited
        categoryCollectionView.reloadItems(at: [indexPath])
        CategoryManager.shared.saveCategoriesStruct(with: categoriesStruct)

        let item = categoriesStruct[indexPath.item].name
        if categoriesSet.contains(item) {
            categoriesSet.remove(item)
            CategoryManager.shared.saveCategoriesSet(with: categoriesSet)
        } else {
            categoriesSet.insert(item)
            CategoryManager.shared.saveCategoriesSet(with: categoriesSet)
        }
    }
}
