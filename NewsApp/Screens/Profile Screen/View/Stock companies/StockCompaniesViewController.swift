//
//  StockCompaniesViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 27.10.2021.
//

import UIKit

class StockCompaniesViewController: UIViewController {
    private var stockCompaniesStruct = [StockCompanies]()
    private var stockCompaniesSet = Set<String>()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stockCompaniesSet = CategoryManager.shared.loadStockCompaniesSet()
        stockCompaniesStruct =  CategoryManager.shared.loadStockCompaniesStruct()
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
        return stockCompaniesStruct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else {
            return UITableViewCell()
        }
        cell.company = stockCompaniesStruct[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let hasFavorited = stockCompaniesStruct[indexPath.item].isFavorited
        stockCompaniesStruct[indexPath.item].isFavorited = !hasFavorited
        stockCompaniesTableView.reloadRows(at: [indexPath], with: .none)
        CategoryManager.shared.saveStockCompaniesStruct(with: stockCompaniesStruct)
        
        let name = stockCompaniesStruct[indexPath.row].symbol
        if stockCompaniesSet.contains(name) {
            stockCompaniesSet.remove(name)
            CategoryManager.shared.saveStockCompaniesSet(with: stockCompaniesSet)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
            NotificationCenter.default.post(name: NSNotification.Name("stockCompaniesSet"), object: stockCompaniesSet)
        } else {
            stockCompaniesSet.insert(name)
            CategoryManager.shared.saveStockCompaniesSet(with: stockCompaniesSet)
            NotificationCenter.default.post(name: NSNotification.Name("stockCompaniesSet"), object: stockCompaniesSet)
        }
    }
}
