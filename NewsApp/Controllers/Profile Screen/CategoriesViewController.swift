//
//  CategoriesViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 28.09.2021.
//

import UIKit


class CategoriesViewController: UIViewController {
    private var categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var categoriesSet:Set = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    private var categoriesArray = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    var tr: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        categoriesSet = CategoryManager.shared.loadCategoriesSet()
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
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCell.identifier, for: indexPath) as? CategoriesCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 15
        cell.categoryLabel.text = categoriesArray[indexPath.item]


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width  - 30, height: (view.frame.width / 4) - 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

//        if let cell = collectionView.cellForItem(at: indexPath),  tr ?? true{
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
//                cell.transform = .init(scaleX: 0.9, y: 0.9)
//                cell.backgroundColor = .green
//            }
//            UserDefaults.standard.setValue(false, forKey: "isSelected")
//            tr = false
//            print(tr)
//        } else if let cell = collectionView.cellForItem(at: indexPath),  !(tr ?? false) {
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
//                cell.transform = .identity
//                cell.backgroundColor = .white
//            }
//            UserDefaults.standard.setValue(true, forKey: "isSelected")
//            tr = true
//            print(tr)
//        }

        let item = categoriesArray[indexPath.item]

        if categoriesSet.contains(item) {
            categoriesSet.remove(item)
            CategoryManager.shared.saveCategories(with: categoriesSet)
        } else {
            categoriesSet.insert(item)
            CategoryManager.shared.saveCategories(with: categoriesSet)
        }
    }
}
