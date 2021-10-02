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

    var documentDirectorypath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

    private let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()

        var folderPath = documentDirectorypath
        folderPath?.appendPathComponent("New test folder")

        guard let pass = folderPath else {
            return
        }
        print(pass)

        let notFirsAppLaunch = defaults.bool(forKey: "isrue")
        print(notFirsAppLaunch)

        if !notFirsAppLaunch {
            try? FileManager.default.createDirectory(at: pass, withIntermediateDirectories: false, attributes: nil)
            let data = try? JSONEncoder().encode(categoriesSet)
            let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
            FileManager.default.createFile(atPath: dataPath!.path, contents: data, attributes: nil)
            defaults.setValue(true, forKey: "isrue")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true

        var folderPath = documentDirectorypath
        folderPath?.appendPathComponent("New test folder")
        let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
        if let newData = FileManager.default.contents(atPath: dataPath!.path) {
            categoriesSet = try! JSONDecoder().decode(Set<String>.self, from: newData)
            print(categoriesSet)
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
        categoryCollectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: CategoriesCell.identifier)
        categoryCollectionView.backgroundColor = UIColor.white
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        view.addSubview(categoryCollectionView)
    }

    var tr = true
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

        if let cell = collectionView.cellForItem(at: indexPath),  tr {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
                cell.transform = .init(scaleX: 0.9, y: 0.9)
//                    self.backgroundColor = .purple
                cell.backgroundColor = .green
//                celllayer.shadowColor = UIColor.purple.cgColor
            }
//            cell.backgroundColor = .green
            tr = false
        } else if let cell = collectionView.cellForItem(at: indexPath),  !tr {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
                cell.transform = .identity
//                    self.backgroundColor = .purple
                cell.backgroundColor = .white
//                celllayer.shadowColor = UIColor.purple.cgColor
            }
            tr = true
        }

        let item = categoriesArray[indexPath.item]

        if categoriesSet.contains(item) {
            categoriesSet.remove(item)
            var folderPath = documentDirectorypath
            folderPath?.appendPathComponent("New test folder")

            guard let pass = folderPath else {
                return
            }
            print(pass)

            try? FileManager.default.createDirectory(at: pass, withIntermediateDirectories: false, attributes: nil)
            let data = try? JSONEncoder().encode(categoriesSet)
            let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
            FileManager.default.createFile(atPath: dataPath!.path, contents: data, attributes: nil)
        } else {
            categoriesSet.insert(item)
            var folderPath = documentDirectorypath
            folderPath?.appendPathComponent("New test folder")
            guard let pass = folderPath else {
                return
            }
            print(pass)

            try? FileManager.default.createDirectory(at: pass, withIntermediateDirectories: false, attributes: nil)
            let data = try? JSONEncoder().encode(categoriesSet)
            let dataPath = folderPath?.appendingPathComponent("categoriesSet.json")
            FileManager.default.createFile(atPath: dataPath!.path, contents: data, attributes: nil)
        }

//        categoryCollectionView.reloadData()
    }
}
