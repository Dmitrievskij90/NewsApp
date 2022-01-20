//
//  StockChartViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 11.01.2022.
//

import Foundation

class StockChartViewModel {
    var stockModel: Box<StockHistoryData?> = Box(nil)
    let diffrience: Box<Double> = Box(0.0)
    var priceLabel: String {
        return String(currentStockCompanyData.price ) + "$"
    }

    var stockChartSymbol: String {
        return currentStockCompanyData.symbol
    }

    private var currentStockCompanyData: StockHeaderCellModel

    init(currentStockCompanyData: StockHeaderCellModel) {
        self.currentStockCompanyData = currentStockCompanyData
        fetchData(result: currentStockCompanyData.symbol)
    }

    private func fetchData(result: String) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        NetworkService.shared.fetchStockChartData(searchedStockCompany: result ) { (res, error) in
            if let err = error {
                print("failed error", err)
            }
            dispatchGroup.leave()

            guard let result = res else {
                return
            }

            dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self = self else {
                    return
                }
                self.stockModel.value = result
                let closeValue = Double(result.values[1].close) ?? 0.0
                self.setDataToDifferenceLabel(closeValue)
            }
        }
    }

    private func setDataToDifferenceLabel(_ closeValue: Double) {
        let currnetValue = Double(self.currentStockCompanyData.price)
        let diffrience = currnetValue - closeValue
        self.diffrience.value = diffrience
    }
}
