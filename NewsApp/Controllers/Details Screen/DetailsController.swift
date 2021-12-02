//
//  DetailsController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.09.2021.
//

import UIKit

class DetailsController: UIViewController {
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var article: Articles
    private let floatingContainerView = FloatingContainerView()
    private let bottomPadding = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

    init(article: Articles) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lificycle methods
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        let logOutButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        logOutButton.tintColor = .black
        navigationItem.rightBarButtonItem = logOutButton
        navigationController?.navigationBar.tintColor = .label

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissFloatinContainerView))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.alpha = 0
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if floatingContainerView.transform == .identity {
            UIView.animate(withDuration: 0.7, delay: 3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.floatingContainerView.transform = .init(translationX: 0, y: -100 - self.bottomPadding)
            }
        }
    }

    // MARK: - setup user interface methods
    // MARK: -
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
        navigationController?.navigationBar.tintColor = .label
        setupCollectinView()
        setupFloatingContainerView()
    }

    private func setupCollectinView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(ImageHeaderCell.self, forCellWithReuseIdentifier: ImageHeaderCell.identifier)
        collectionView.register(NewsDetailCell.self, forCellWithReuseIdentifier: NewsDetailCell.identifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
    }

    private func setupFloatingContainerView() {
        let height = view.frame.height / 9
        view.addSubview(floatingContainerView)
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: height))
        floatingContainerView.imageView.sd_setImage(with: URL(string: article.urlToImage ?? ""))
        floatingContainerView.transitionHandler = { [weak self] in
            let viewController = WebNewsViewController()
            viewController.modalPresentationStyle = .fullScreen
            viewController.urlString = self?.article.url ?? ""
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: - FloatingContainerView animation methods
    // MARK: -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 10 {
            if floatingContainerView.transform == .identity {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                    self.floatingContainerView.transform = .init(translationX: 0, y: -100 - self.bottomPadding)
                }
            }
        }
    }

    @objc func handleDismissFloatinContainerView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.floatingContainerView.transform = .identity
        }
    }

    @objc func shareButtonTapped() {
        let aiv = UIActivityViewController(activityItems: [article.url], applicationActivities: nil)
        present(aiv, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout methods
// MARK: -
extension DetailsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageHeaderCell.identifier, for: indexPath) as? ImageHeaderCell else {
                return UICollectionViewCell()
            }
            cell.dataSource = article
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailCell.identifier, for: indexPath) as? NewsDetailCell else {
            return UICollectionViewCell()
        }
        cell.dataSource = article
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return.init(width: view.frame.width, height: view.frame.height / 3)
        }
        return .init(width: view.frame.width, height: view.frame.height / 2)
    }


}

