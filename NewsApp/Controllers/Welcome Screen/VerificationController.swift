//
//  VerifyController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 07.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class VerificationController: UIViewController {
    private let alertView = VerificationAlertView()
    private let letsGoButton: UIButton = {
        let button = BaseButton(type: .system)
        button.setTitle("Let's go", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(hex: 0x16697A)
        button.addTarget(self, action: #selector(letsGoButonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().currentUser?.reload()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = .label

        view.addSubview(letsGoButton)
        letsGoButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 50, right: 0), size: .init(width: 100, height: 50))
        letsGoButton.centerXInSuperview()

        setupVerificationAlertView()
    }

    private func setupVerificationAlertView() {
        view.addSubview(alertView)
        alertView.anchor(top: view.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16) ,size: .init(width: 0, height: view.frame.width))
        alertView.tapHandler = {
            Auth.auth().currentUser?.reload()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.alertView.frame.origin.y = self.view.frame.maxY
            }
        }
    }

    func showAlertView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.alertView.frame.origin.y = self.view.frame.midY
        }
    }

    @objc func cancelButonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc func letsGoButonPressed() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        user.reload { _ in
            switch user.isEmailVerified {
            case true:
                self.presentBaseTabBarController()
            case false:
                self.showAlertView()
            }
        }
    }

    private func presentBaseTabBarController() {
        let dV = BaseTabBarController()
        dV.modalPresentationStyle = .fullScreen
        present(dV, animated: true, completion: nil)
    }
}
