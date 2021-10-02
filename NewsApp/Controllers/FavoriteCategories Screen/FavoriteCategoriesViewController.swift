//
//  FavoriteCategoriesViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 29.09.2021.
//

import UIKit

class FavoriteCategoriesViewController: UIViewController {

    private var categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    var set = Set<String>()
//     var set:Set = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    var documentDirectorypath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)


    override func viewDidLoad() {
        super.viewDidLoad()

//        set = UserDefaults.standard.value(forKey: "categoriesSet") as? Set<String> ?? Set<String>()
//        print(set)
//        var folderPath = documentDirectorypath
//        folderPath?.appendPathComponent("New test folder")
//        let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
//        if let newData = FileManager.default.contents(atPath: dataPath!.path) {
//            set = try! JSONDecoder().decode(Set<String>.self, from: newData)
//            print(set)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var folderPath = documentDirectorypath
        folderPath?.appendPathComponent("New test folder")
        let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
        if let newData = FileManager.default.contents(atPath: dataPath!.path) {
            set = try! JSONDecoder().decode(Set<String>.self, from: newData)
            print(set)
        }

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

extension FavoriteCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categoriesArray.count
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
