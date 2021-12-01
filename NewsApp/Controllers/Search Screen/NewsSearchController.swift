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
    private var articles = [Articles]()
    private var user = User()
    private var timer: Timer?
    private let searhController = UISearchController(searchResultsController: nil)
    private let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please search term above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    // MARK: - Lificycle methods
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.alpha = 1
    }

    // MARK: - setup user interface methods
    // MARK: -
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
        setupCollectinView()
        setupSearchBar()

        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 0, bottom: 0, right: 0))
        enterSearchTermLabel.centerXInSuperview()
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
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout methods
// MARK: -
extension NewsSearchController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = articles.count != 0
        return articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        cell.article = articles[indexPath.item]
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
        let article = articles[indexPath.item]
        let appDetailController = DetailsController(article: article)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

extension NewsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        user = CategoryManager.shared.loadUser()

        let term = searchText.replacingOccurrences(of: " ", with: "")
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            NetworkService.shared.fetchNews(searchTerm: term, preferredCountry: self.user.country) { (results, error) in
                if let err = error {
                    print("Failed to fetch apps:", err)
                    return
                }
                self.articles = results?.articles ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
}



