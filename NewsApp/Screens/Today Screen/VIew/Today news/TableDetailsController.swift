//
//  TableDetailsController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.10.2021.
//

import UIKit

class TableDetailsController: UIViewController {
    var dismissHandler: (() -> Void)?
    var dataSource: TodayCellModel?

    let floatingContainerView = FloatingContainerView()
    private let bottomPadding = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .init(hex: 0x16697A)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = true
        tableView.register(ImageHeaderTableCell.self, forCellReuseIdentifier: ImageHeaderTableCell.identifier)
        tableView.register(NewsDetailTableCell.self, forCellReuseIdentifier: NewsDetailTableCell.identifier)
        return tableView
    }()

    // MARK: - lifecycle methods
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true

        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveFloatinContainerView))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTapGestureRecognizer)
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
        self.view = view
        view.backgroundColor = .white

        setupTableView()
        setupCloseButton()
        setupShareButton()
        setupFloatingContainerView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        let height = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height.height, right: 0)
    }

    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
    }

    private func setupShareButton() {
        view.addSubview(shareButton)
        shareButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
    }

    private func setupFloatingContainerView() {
        let height = view.frame.height / 9
        view.addSubview(floatingContainerView)
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: height))
        floatingContainerView.imageView.sd_setImage(with: URL(string: dataSource?.image ?? ""))
        floatingContainerView.transitionHandler = { [weak self] in
            let newsURL = self?.dataSource?.url ?? ""
            let viewController = WebNewsViewController(urlString: newsURL)
            viewController.modalPresentationStyle = .fullScreen
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: - Actions methods
    // MARK: -
    @objc private func moveFloatinContainerView() {
        if floatingContainerView.transform == .identity {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.floatingContainerView.transform = .init(translationX: 0, y: -100 - self.bottomPadding)
            }
        } else {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.floatingContainerView.transform = .identity
            }
        }
    }

    @objc private func shareButtonTapped() {
        let aiv = UIActivityViewController(activityItems: [dataSource?.url ?? ""], applicationActivities: nil)
        present(aiv, animated: true, completion: nil)
    }

    @objc private func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
}

// MARK: - UITableViewDelegate and  UITableViewDataSource methods
// MARK: -
extension TableDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageHeaderTableCell.identifier, for: indexPath) as? ImageHeaderTableCell else {
                return UITableViewCell()
            }
            cell.dataSource = dataSource
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsDetailTableCell.identifier, for: indexPath) as? NewsDetailTableCell else {
            return UITableViewCell()
        }

        cell.dataSource = dataSource
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 400
        }
        return view.frame.height / 2
    }
}
