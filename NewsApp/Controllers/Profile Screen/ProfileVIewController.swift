//
//  ProfileVIewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit
import KeychainAccess

class ProfileVIewController: UIViewController {
    private let keychain = Keychain()

    let exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Done", for: .normal)
        button.contentMode = .center
        button.backgroundColor = .init(hex: 0xBE1FBB)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(exitButonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        view.addSubview(exitButton)
        exitButton.centerInSuperview(size: .init(width: 100, height: 100), constantY: 100)
    }

    @objc func exitButonPressed() {
        keychain["remember"] = nil

        let destinationVC = WelcomeController()
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }
}
