//
//  MyViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 31.10.2021.
//

import UIKit
import Charts

class StockChartViewController: UIViewController, ChartViewDelegate {
    private var currentStockCompanyData: StockData
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .medium)
        aiv.color = .darkGray
        aiv.hidesWhenStopped = true
        return aiv
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .init(hex: 0xDB6400)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    private let halfView: UIView = {
        let halfView = UIView()
        halfView.backgroundColor = .init(hex: 0x16697A)
        halfView.layer.cornerRadius = 15
        return halfView
    }()

    private let companyLogoImageView: UIImageView = {
        let companyLogo = UIImageView()
        companyLogo.image = UIImage(named: "AMZN")
        companyLogo.contentMode = .scaleAspectFit
        companyLogo.constrainWidth(constant: 100)
        companyLogo.constrainHeight(constant: 100)
        return companyLogo
    }()

    private let companyLabel: UILabel = {
        let companyLabel = UILabel()
        companyLabel.text = "AMAZON"
        companyLabel.font = UIFont(name: "ScopeOne-Regular", size: 25)
        companyLabel.textColor = .black
        companyLabel.constrainHeight(constant: 50)
        return companyLabel
    }()

    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "2021-10-31"
        dateLabel.font = UIFont(name: "ScopeOne-Regular", size: 20)
        dateLabel.textColor = .black
        return dateLabel
    }()

    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = "3450,44 $"
        priceLabel.font = UIFont(name: "ScopeOne-Regular", size: 45)
        priceLabel.textColor = .black
        return priceLabel
    }()

    private let differenceButton: UIButton = {
        let differenceButton = UIButton()
        differenceButton.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        differenceButton.tintColor = .init(hex: 0xDB6400)
        differenceButton.titleLabel?.font = UIFont(name: "ScopeOne-Regular", size: 25)
        differenceButton.semanticContentAttribute = .forceRightToLeft
        differenceButton.addTarget(self, action: #selector(differenceButtonTapped), for: .touchUpInside)
        return differenceButton
    }()

    private var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.pinchZoomEnabled = false
        lineChartView.backgroundColor = .clear
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.chartDescription?.enabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(false)

        lineChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChartView.leftAxis.setLabelCount(6, force: false)
        lineChartView.leftAxis.labelTextColor = .white
        lineChartView.leftAxis.axisLineColor = .white
        lineChartView.leftAxis.labelPosition = .outsideChart
        lineChartView.leftAxis.drawGridLinesBehindDataEnabled = true

        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChartView.xAxis.setLabelCount(6, force: false)
        lineChartView.xAxis.labelTextColor = .white
        lineChartView.xAxis.axisLineColor = .white

        lineChartView.legend.font = .boldSystemFont(ofSize: 15)
        lineChartView.legend.textColor = .white

        return lineChartView
    }()

    init(currentStockCompanyData: StockData) {
        self.currentStockCompanyData = currentStockCompanyData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        lineChartView.delegate = self
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view

        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()

        view.backgroundColor = .clear
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 1

        setupHalfView()
        setupStackView()
        setupCloseButton()
        setupLabelsData()
    }

    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
    }

    private func setupHalfView() {
        view.addSubview(halfView)
        halfView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 5, bottom: 0, right: 5), size: .init(width: 0, height: view.frame.height / 2))
        halfView.addSubview(lineChartView)
        lineChartView.fillSuperview(padding: .init(top: 70, left: 0, bottom: 70, right: 0))
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [companyLogoImageView, companyLabel, dateLabel, priceLabel, differenceButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center

        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: halfView.topAnchor, trailing: view.trailingAnchor)
    }

    private func setupLabelsData() {
        priceLabel.text = String(currentStockCompanyData.price ) + "$"
        companyLogoImageView.image = UIImage(named: currentStockCompanyData.symbol)
        companyLabel.text = currentStockCompanyData.symbol
        dateLabel.text = Helpers.shared.getCurrentDate()
    }

    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        activityIndicator.startAnimating()
        dispatchGroup.enter()
        NetworkService.shared.fetchStockChartData(searchedStockCompany: currentStockCompanyData.symbol ) { (res, error) in
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
                self.activityIndicator.stopAnimating()
                let closeValue = Double(result.values[0].close) ?? 0.0
                self.setDataToDifferenceLabel(closeValue)

                var entries = [ChartDataEntry]()
                for (index, value) in result.values.reversed().enumerated() {
                    entries.append(ChartDataEntry(x: Double(index), y: Double(value.close ) ?? 0.0))
                }
                self.setupLineChartDataSet(entries)
            }
        }
    }

    private func setDataToDifferenceLabel(_ closeValue: Double) {
        let currnetValue = Double(self.currentStockCompanyData.price)
        let diffrience = currnetValue - closeValue
        let price = String(format: "%.2f", diffrience)
        if diffrience > 0 {
            differenceButton.setTitleColor(.green, for: .normal)
            differenceButton.setTitle("(+\(price))", for: .normal)
        } else {
            differenceButton.setTitle("(\(price))", for: .normal)
            differenceButton.setTitleColor(.red, for: .normal)
        }
    }

    private func setupLineChartDataSet(_ entries: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: entries, label: "Price for the last 30 days")
        set.drawCirclesEnabled = false
        set.mode = .linear
        set.lineWidth = 3
        set.setColor(.white)
        set.fill = Fill(color: .init(hex: 0xDB6400))
        set.fillAlpha = 0.5
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .white
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChartView.data = data
    }

    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    @objc func differenceButtonTapped() {
        presentOneButtonAlert(withTitle: "", message: "The difference between the current price and yesterday's closing price")
    }
}
