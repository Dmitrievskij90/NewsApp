//
//  WelcomeController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.09.2021.
//

import UIKit

class WelcomeController: UIViewController {

    let appLabel: UILabel = {
        let label = UILabel()
        label.text = "JUST NEWS"
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("REGISTER", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.contentMode = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(registerButtopnTapped), for: .touchUpInside)
        return button
    }()

    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN IN", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.darkGray, for: .normal)
        button.contentMode = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let stackVIew = UIStackView(arrangedSubviews: [
            registerButton,
            signInButton,
        ])
        stackVIew.axis = .vertical
        stackVIew.spacing = 16
        stackVIew.alignment = .fill
        stackVIew.distribution = .fillEqually
        view.addSubview(stackVIew)
        stackVIew.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 150, right: 0) ,size: .init(width: 200, height: 100))
        stackVIew.centerXInSuperview()
    }

    @objc func registerButtopnTapped() {
        let destinationVC = RegisterController()
        let navVC = UINavigationController(rootViewController: destinationVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }

    @objc func signinButtonTapped() {
        if !KeychainManager.shared.isUserSignedIn.isEmpty {
            presentBaseTabBarController()
        } else {
//            presentRegisterAlert(withTitle: "Please register or sign in", message: "")
        }
    }

    private func presentBaseTabBarController() {
        let dV = BaseTabBarController()
        dV.modalPresentationStyle = .fullScreen
        present(dV, animated: true, completion: nil)
    }
}
