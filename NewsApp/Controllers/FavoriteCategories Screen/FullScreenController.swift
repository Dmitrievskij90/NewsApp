//
//  FullScreenController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 06.10.2021.
//

import UIKit

class FullScreenController: UIViewController {

    var dismissHandler: (() ->())?
    var dataSourse: String?
    private var results = [Articles]()

    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .init(hex: 0xBE1FBB)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.isUserInteractionEnabled = true
        tableView.register(AppFullscreenHeaderCell.self, forCellReuseIdentifier: AppFullscreenHeaderCell.identifier)
        tableView.register(NewsCategoryCell.self, forCellReuseIdentifier: NewsCategoryCell.identifier)
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .medium)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        fetchTodayNews()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.backgroundColor = .white

        setupTableView()
        setupCloseButton()

//        view.addSubview(activityIndicator)
//        activityIndicator.centerInSuperview()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        let height = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height.height, right: 0)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }

    private func fetchTodayNews() {
        let dispatchGroup = DispatchGroup()

        let country = UserDefaults.standard.value(forKey: "chosenCountry") as? String ?? "us"

        dispatchGroup.enter()
        NetworkService.shared.fetchCategoriesNews(preferredCountry: country, preferredCategoty: dataSourse ?? "sports") { (results, error) in
            if let err = error {
                print("Can't fetch today news", err)
            }
            self.results = results?.articles ?? []
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }

    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
    }

    @objc func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
}

extension FullScreenController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppFullscreenHeaderCell.identifier, for: indexPath) as? AppFullscreenHeaderCell else {
                return UITableViewCell()
            }
            cell.favoriteCell.dataSourse = dataSourse
            cell.favoriteCell.layer.cornerRadius = 0
            cell.clipsToBounds = true
            cell.backgroundView = nil
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCategoryCell.identifier, for: indexPath) as? NewsCategoryCell else {
            return UITableViewCell()
        }

        let res = results[indexPath.row]

        cell.results = res
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        }
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
