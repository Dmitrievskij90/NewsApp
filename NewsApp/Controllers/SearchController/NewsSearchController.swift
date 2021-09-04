//
//  NewsSearchController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import UIKit

class NewsSearchController: UIViewController {

    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())

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
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.identifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
}

extension NewsSearchController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
}




