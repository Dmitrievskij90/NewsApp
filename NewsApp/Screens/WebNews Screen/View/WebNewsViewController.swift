//
//  WebNewsViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 09.09.2021.
//

import UIKit
import WebKit

class WebNewsViewController: UIViewController, WKNavigationDelegate {
    private var webView = WKWebView()
    private var urlString: String

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        loadNews()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
        navigationController?.navigationBar.tintColor = .label
        view.addSubview(webView)
        webView.fillSuperview()
    }

    private func loadNews() {
        guard let url = URL(string: urlString) else {
            return
        }
        let requesr = URLRequest(url: url)
        webView.load(requesr)
        webView.navigationDelegate = self
    }
}
