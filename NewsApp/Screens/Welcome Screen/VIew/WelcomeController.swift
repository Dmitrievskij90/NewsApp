//
//  WelcomeController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.09.2021.
//

import UIKit

class WelcomeController: UIViewController {
    private let viewModel = WelcomeControllerViewModel()

    private let appLabel: UILabel = {
        let label = UILabel(text: "JUST NEWS", font: .boldSystemFont(ofSize: 35), textColor: .black)
        label.textAlignment = .center
        return label
    }()

    private let registerButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.createGraphiteButton(title: "REGISTER")
        button.addTarget(self, action: #selector(registerButtopnTapped), for: .touchUpInside)
        return button
    }()

    private let signInButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.createWhiteButton(title: "SIGN IN")
        button.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.validateIsItFirstAppLaunch()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        view.addSubview(appLabel)
        appLabel.centerInSuperview(size: .init(width: 200, height: 200), constantY: -100)

        setupStackView()
    }

    private func setupStackView() {
        let height = view.frame.height / 7.5
        let width = view.frame.width / 2
        let stackVIew = UIStackView(arrangedSubviews: [
            registerButton,
            signInButton
        ])
        stackVIew.axis = .vertical
        stackVIew.spacing = 16
        stackVIew.alignment = .fill
        stackVIew.distribution = .fillEqually
        view.addSubview(stackVIew)
        stackVIew.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: height, right: 0), size: .init(width: width, height: height ))
        stackVIew.centerXInSuperview()
    }

    @objc func registerButtopnTapped() {
        let destinationVC = RegisterController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    @objc func signinButtonTapped() {
        if !AppSettingsManager.shared.isUserSignedIn.isEmpty {
            presentBaseTabBarController()
        } else {
            let destinationVC = LoginViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    private func presentBaseTabBarController() {
        let dV = BaseTabBarController()
        navigationController?.pushViewController(dV, animated: true)
    }
}
