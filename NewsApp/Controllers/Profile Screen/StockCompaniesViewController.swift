//
//  StockCompaniesViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.10.2021.
//

import UIKit

class StockCompaniesViewController: UIViewController {

    let arr = ["Amazon", "Apple", "Coca-Cola", "Facebook", "Google", "IBM", "Intel", "McDonald’s", "Microsoft", "Netflix", "Nike", "Pepsi", "Starbucks", "Tesla", "Visa"]

    private let stockCompaniesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black

        setupTableView()
    }

    private func setupTableView() {
        stockCompaniesTableView.dataSource = self
        stockCompaniesTableView.delegate = self
        view.addSubview(stockCompaniesTableView)
        stockCompaniesTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

extension StockCompaniesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else {
            return UITableViewCell()
        }

        cell.stockImageView.image = UIImage(named: arr[indexPath.row])
        cell.stockLabel.text = arr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
