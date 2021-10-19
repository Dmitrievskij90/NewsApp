//
//  FullScreenController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.10.2021.
//

import UIKit

class FullScreenCategoriesViewController: UIViewController {
    var preferredCategoty: String?
    private var results = [Articles]()
    private var categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .medium)
        aiv.color = .darkGray
        aiv.hidesWhenStopped = true
        return aiv
    }()

    private let refreshControl = UIRefreshControl()
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoryNews()

        refreshControl.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        categoryCollectionView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = preferredCategoty
        tabBarController?.tabBar.alpha = 1
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black

        setupCollectinView()

        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }

    private func setupCollectinView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        categoryCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        categoryCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        categoryCollectionView.backgroundColor = UIColor.white
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        view.addSubview(categoryCollectionView)
    }

    private func fetchCategoryNews(isTrue: Bool = true) {
        if isTrue {
            activityIndicator.startAnimating()
        }

        let dispatchGroup = DispatchGroup()

        let country = UserDefaults.standard.value(forKey: "chosenCountry") as? String ?? "us"
        dispatchGroup.enter()
        NetworkService.shared.fetchCategoriesNews(preferredCountry: country, preferredCategoty: preferredCategoty ?? "") { (results, error) in
            if let err = error {
                print("Failed to fetch apps:", err)
                return
            }
            self.results = results?.articles ?? []
            dispatchGroup.leave()

            dispatchGroup.notify(queue: .main) {
                self.activityIndicator.stopAnimating()
                self.categoryCollectionView.reloadData()
            }
        }
    }

    @objc func refreshHandler() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.refreshControl.endRefreshing()
        })
        self.fetchCategoryNews(isTrue: false)
    }
}

extension FullScreenCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        cell.results = results[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 68
        return .init(width: view.frame.width - 26, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return .init(top: 12, left: 13, bottom: 12, right: 13)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let res = results[indexPath.item]
        let appDetailController = DetailsController()
        appDetailController.dataSource = res
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}
