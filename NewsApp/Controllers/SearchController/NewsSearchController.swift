//
//  NewsSearchController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 04.09.2021.
//

import UIKit
import SDWebImage

class NewsSearchController: UIViewController {

    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var results = [Articles]()
    private var timer: Timer?
    private let searhController = UISearchController(searchResultsController: nil)
    private let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please search term above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.alpha = 1
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
        setupCollectinView()
        setupSearchBar()

        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 100, bottom: 0, right: 100))
    }

    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searhController
        navigationItem.hidesSearchBarWhenScrolling = false
        searhController.searchBar.delegate = self
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
        enterSearchTermLabel.isHidden = results.count != 0
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            return UICollectionViewCell()
        }

        let res = results[indexPath.item]

        cell.authorLabel.text = res.source.name
        cell.titleLabel.text = res.title

        if let image = res.urlToImage, res.urlToImage != "" {
            cell.imageView.sd_setImage(with: URL(string: image))
        } else {
            cell.imageView.image = UIImage(named: "news_image")
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 32, height: 100)
    }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let res = results[indexPath.item]
        let appDetailController = DetailsController()
        appDetailController.dataSource = res
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

extension NewsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()

        let term = searchText.replacingOccurrences(of: " ", with: "")

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            NetworkService.shared.fetchNews(searchTerm: term) { (results, error) in
                if let err = error {
                    print("Failed to fetch apps:", err)
                    return
                }
                self.results = results?.articles ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
}



