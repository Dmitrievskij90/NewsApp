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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifecycle methods
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        updateControllerWithViewModel()
        
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

    // MARK: - setup user interface methods
    // MARK: -
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        categoryCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        categoryCollectionView.register(FullScreenCategoriesNewsCell.self, forCellWithReuseIdentifier: FullScreenCategoriesNewsCell.identifier)
        categoryCollectionView.backgroundColor = UIColor.white
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        view.addSubview(categoryCollectionView)
    }

    // MARK: - viewModel methods
    // MARK: -
    private func updateControllerWithViewModel() {
        viewModel.categoryNews.bind { _ in
            DispatchQueue.main.async { [weak self] in
                self?.categoryCollectionView.reloadData()
            }
        }
        
        viewModel.stopAnimating = { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    @objc private func refreshHandler() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.refreshControl.endRefreshing()
        }
        viewModel.refreshData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate and UICollectionViewDelegateFlowLayout methods
// MARK: -
extension FullScreenCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryNews.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullScreenCategoriesNewsCell.identifier, for: indexPath) as? FullScreenCategoriesNewsCell else {
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
