//
//  TodayController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 11.09.2021.
//

import UIKit
import KeychainAccess

class TodayController: UIViewController {
    private var todayCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var results = [Articles]()

    private let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.hidesWhenStopped = true
        return aiv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .label
        fetchTodayNews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.alpha = 1
    }

    private func fetchTodayNews() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        activityIndicator.startAnimating()
        NetworkService.shared.fetchTodayNews { (results, error) in
            if let err = error {
                print("Can't fetch today news", err)
            }
            self.results = results?.articles ?? []
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.todayCollectionView.reloadData()
        }
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view

        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButonPressed))
        navigationItem.rightBarButtonItem = refreshButton
        refreshButton.tintColor = .label

        setupCollectinView()

        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }

    @objc func refreshButonPressed() {
        fetchTodayNews()
    }

    private func setupCollectinView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        todayCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        todayCollectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayCell.identifier)
        todayCollectionView.backgroundColor = UIColor.white
        todayCollectionView.dataSource = self
        todayCollectionView.delegate = self

        view.addSubview(todayCollectionView)
    }
}

extension TodayController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCell.identifier, for: indexPath) as? TodayCell else {
            return UICollectionViewCell()
        }

        let res = results[indexPath.item]

        cell.results = res
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: 400)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let res = results[indexPath.item]
        let appDetailController = DetailsController()
        appDetailController.dataSource = res
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}
