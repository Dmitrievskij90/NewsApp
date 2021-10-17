//
//  TodayController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 11.09.2021.
//

import UIKit
import KeychainAccess

class TodayController: UIViewController {

    private var appFullscreenController = TableDetailsController()
    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var appFullscreenBeginOffset: CGFloat = 0
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private var startingFrame: CGRect?

    private var todayCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    private var results = [Articles]()
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

        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0

        navigationController?.navigationBar.tintColor = .label
        fetchTodayNews()

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        todayCollectionView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        setupCollectinView()

        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }

    private func setupCollectinView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        todayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        todayCollectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayCell.identifier)
        todayCollectionView.backgroundColor = UIColor.white
        todayCollectionView.dataSource = self
        todayCollectionView.delegate = self

        view.addSubview(todayCollectionView)
        todayCollectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }

    private func fetchTodayNews(isTrue: Bool = true) {
        let dispatchGroup = DispatchGroup()

        let country = UserDefaults.standard.value(forKey: "chosenCountry") as? String ?? "us"

        if isTrue {
            activityIndicator.startAnimating()
        }

        dispatchGroup.enter()
        NetworkService.shared.fetchTodayNews(preferredCountry: country) { (results, error) in
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

    @objc func refresh() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.refreshControl.endRefreshing()
        })
        self.fetchTodayNews(isTrue: false)
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

                guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? ImageHeaderTableCell else {
                    return
                }

                self.appFullscreenController.closeButton.alpha = 0
                self.appFullscreenController.floatingContainerView.alpha = 0
                cell.layoutIfNeeded()
            }
        } completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.todayCollectionView.isUserInteractionEnabled = true
        }
    }

    //MARK: - Методы анимации ячейки для одного приложения

    private func setupAppSingleFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = TableDetailsController()

        appFullscreenController.dataSource = results[indexPath.item]

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
                guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? ImageHeaderTableCell else {
                    return
                }
                cell.layoutIfNeeded()
            }
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleRemoveView()
            }
        }
    }

    private func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = todayCollectionView.cellForItem(at: indexPath) else {
            return
        }

        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }

        self.startingFrame = startingFrame
    }

    private func setupSingleAppFullScreenStartingPosition(_ indexPath: IndexPath) {
        let fullScreenView = appFullscreenController.view!

        view.addSubview(fullScreenView)

        addChild(appFullscreenController)

        self.todayCollectionView.isUserInteractionEnabled = false

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

            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? ImageHeaderTableCell else {
                return
            }
//            cell.topConstaraint?.constant = 48
            cell.layoutIfNeeded()
        }
    }

    private func showSingleAppFullScreen(_ indexPath: IndexPath) {
        setupAppSingleFullscreenController(indexPath)
        setupSingleAppFullScreenStartingPosition(indexPath)
        beginFullscreenAnimation()
    }

}

extension TodayController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
//        let res = results[indexPath.item]
//        let appDetailController = DetailsController()
//        appDetailController.dataSource = res
//        navigationController?.pushViewController(appDetailController, animated: true)
        showSingleAppFullScreen(indexPath)
    }
}
