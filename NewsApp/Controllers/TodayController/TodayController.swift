//
//  TodayController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 11.09.2021.
//

import UIKit

class TodayController: UIViewController {

    private var todayCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var results = [Articles]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTodayNews()
    }

    private func fetchTodayNews() {
        NetworkService.shared.fetchTodayNews { (results, error) in
            if let err = error {
                print("Can't fetch today news", err)
            }
            self.results = results?.articles ?? []
            print(self.results.count)
            DispatchQueue.main.async {
                self.todayCollectionView.reloadData()
            }
        }
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view

        setupCollectinView()
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: 400)
    }

}
