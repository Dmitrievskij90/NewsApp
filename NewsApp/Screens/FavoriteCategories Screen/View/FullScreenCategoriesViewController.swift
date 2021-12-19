//
//  FullScreenController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.10.2021.
//

import UIKit

class FullScreenCategoriesViewController: UIViewController {
    private var categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var timer: Timer?
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = BaseActivityIndicator(style: .medium)
    private let viewModel: FullSceenCategoriesViewModel
    
    init(viewModel: FullSceenCategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        
        refreshControl.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        categoryCollectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        title = viewModel.category
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
        categoryCollectionView.register(FavoriteCategoryNewsCell.self, forCellWithReuseIdentifier: FavoriteCategoryNewsCell.identifier)
        categoryCollectionView.backgroundColor = UIColor.white
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        view.addSubview(categoryCollectionView)
    }
    
    private func bindData() {
        viewModel.categoryNews.bind { _ in
            DispatchQueue.main.async { [weak self] in
                self?.categoryCollectionView.reloadData()
            }
        }
        
        viewModel.stopAnimating = { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    @objc func refreshHandler() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.refreshControl.endRefreshing()
        })
        viewModel.refreshData()
    }
}

extension FullScreenCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryNews.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCategoryNewsCell.identifier, for: indexPath) as? FavoriteCategoryNewsCell else {
            return UICollectionViewCell()
        }
        cell.article = viewModel.categoryNews.value[indexPath.item]
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
                let article = viewModel.categoryNews.value[indexPath.item]
                let appDetailController = DetailsController(article: article)
                navigationController?.pushViewController(appDetailController, animated: true)
    }
}
