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
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: urlString) else {
            return
        }
        let requesr = URLRequest(url: url)
        webView.load(requesr)
        webView.navigationDelegate = self
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
        navigationController?.navigationBar.tintColor = .label
        view.addSubview(webView)
        webView.fillSuperview()
    }

}

//"https://www.apple.com"
