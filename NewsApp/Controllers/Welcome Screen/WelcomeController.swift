//
//  WelcomeController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.09.2021.
//

import UIKit
import KeychainAccess

class WelcomeController: UIViewController {
    private let keychain = Keychain()
    private let defaults = UserDefaults.standard

    let appLabel: UILabel = {
        let label = UILabel()
        label.text = "JUST NEWS"
        label.font = .boldSystemFont(ofSize: 35)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    let registerButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.setTitle("REGISTER", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.init(hex: 0x4EFDD), for: .normal)
        button.backgroundColor = .init(hex: 0x494d4e)
        button.addTarget(self, action: #selector(registerButtopnTapped), for: .touchUpInside)
        return button
    }()

    let signInButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.setTitle("SIGN IN", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.init(hex: 0x4EFDD).cgColor
        button.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        validateIsItFirstAppLaunch()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        view.addSubview(appLabel)
        appLabel.centerInSuperview(size: .init(width: 200, height: 200), constantY: -100)

        setupStackView()
    }

    private func validateIsItFirstAppLaunch() {
        if !AppSettingsManager.shared.notFirsAppLaunch {
            keychain["remember"] = nil
            defaults.setValue(true, forKey: "isTrue")
        }
    }

    private func setupStackView() {
        let height = view.frame.height / 7.5
        let width = view.frame.width / 2
        let stackVIew = UIStackView(arrangedSubviews: [
            registerButton,
            signInButton,
        ])
        stackVIew.axis = .vertical
        stackVIew.spacing = 16
        stackVIew.alignment = .fill
        stackVIew.distribution = .fillEqually
        view.addSubview(stackVIew)
        stackVIew.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: height, right: 0) ,size: .init(width: width, height: height ))
        stackVIew.centerXInSuperview()
    }

    @objc func registerButtopnTapped() {
        let destinationVC = RegisterController()
        let navVC = UINavigationController(rootViewController: destinationVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
//        let destinationVC = VerificationController()
//        let navVC = UINavigationController(rootViewController: destinationVC)
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: true, completion: nil)
    }

    @objc func signinButtonTapped() {
        if !AppSettingsManager.shared.isUserSignedIn.isEmpty {
            presentBaseTabBarController()
        } else {
            let destinationVC = LoginViewController()
            let navVC = UINavigationController(rootViewController: destinationVC)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true, completion: nil)
        }
    }

    private func presentBaseTabBarController() {
        let dV = BaseTabBarController()
        dV.modalPresentationStyle = .fullScreen
        present(dV, animated: true, completion: nil)
    }
}
