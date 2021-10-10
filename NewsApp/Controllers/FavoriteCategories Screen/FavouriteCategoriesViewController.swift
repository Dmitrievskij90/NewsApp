//
//  FavoriteCategoriesViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 29.09.2021.
//

import UIKit

class FavouriteCategoriesViewController: UIViewController {
    private var categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var set = Set<String>()
    private var categories = [String]()
    private var startingFrame: CGRect?
    private var appFullscreenController = FullScreenController()
    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var appFullscreenBeginOffset: CGFloat = 0
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        set = CategoryManager.shared.loadCategoriesSet()
        categories = set.sorted()
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
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
        categoryCollectionView.register(FavoriteCategoriesCell.self, forCellWithReuseIdentifier: FavoriteCategoriesCell.identifier)
        categoryCollectionView.backgroundColor = UIColor.white
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        view.addSubview(categoryCollectionView)
    }

    func handleRemoveView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {

            self.blurVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity

            guard let startingFrame = self.startingFrame else {
                return
            }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height

            self.view.layoutIfNeeded()
            self.appFullscreenController.tableView.contentOffset = .zero

            self.tabBarController?.tabBar.transform = .identity
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height

                guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else {
                    return
                }
                self.appFullscreenController.closeButton.alpha = 0
                cell.layoutIfNeeded()
            }
        } completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.categoryCollectionView.isUserInteractionEnabled = true
        }
    }

    //MARK: - Методы анимации ячейки для одного приложения

    private func setupAppSingleFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = FullScreenController()

        appFullscreenController.dataSourse = categories[indexPath.item]

        appFullscreenController.dismissHandler = {
            self.handleRemoveView()
        }

        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)
    }

    @objc func handleDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }
        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        let translationY = gesture.translation(in: appFullscreenController.view).y

        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                var scale = 1 - trueOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleRemoveView()
            }
        }
    }

    private func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = categoryCollectionView.cellForItem(at: indexPath) else {
            return
        }

        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }

        self.startingFrame = startingFrame
    }

    private func setupSingleAppFullScreenStartingPosition(_ indexPath: IndexPath) {
        let fullScreenView = appFullscreenController.view!

        view.addSubview(fullScreenView)

        addChild(appFullscreenController)

        self.categoryCollectionView.isUserInteractionEnabled = false

        setupStartingCellFrame(indexPath)

        guard let startingFrame = self.startingFrame else {
            return
        }

        fullScreenView.translatesAutoresizingMaskIntoConstraints = false

        topConstraint = fullScreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullScreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullScreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)

        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        self.view.layoutIfNeeded()
    }

    private func beginFullscreenAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.blurVisualEffectView.alpha = 1

            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height

            self.view.layoutIfNeeded()

            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height + 100

            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else {
                return
            }
            cell.layoutIfNeeded()
        }
    }

    private func showSingleAppFullScreen(_ indexPath: IndexPath) {
        setupAppSingleFullscreenController(indexPath)
        setupSingleAppFullScreenStartingPosition(indexPath)
        beginFullscreenAnimation()
    }

}

extension FavouriteCategoriesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FavouriteCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return set.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCategoriesCell.identifier, for: indexPath) as? FavoriteCategoriesCell else {
            return UICollectionViewCell()
        }

        cell.layer.cornerRadius = 15
        cell.dataSourse = categories[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 24, left: 0, bottom: 24, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showSingleAppFullScreen(indexPath)
    }
}

