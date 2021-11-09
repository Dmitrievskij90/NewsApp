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
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private let alertView = VerificationAlertView()
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
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

        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0

        setupVerificationAlertView()
    }

    private func setupVerificationAlertView() {
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = alertView.topAnchor.constraint(equalTo: view.bottomAnchor)
        topConstraint?.isActive = true
        bottomConstraint = alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        bottomConstraint?.isActive = false
        alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true

        alertView.tapHandler = {
            Auth.auth().currentUser?.reload()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.topConstraint?.isActive = true
                self.bottomConstraint?.isActive = false
                self.blurVisualEffectView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    func showAlertView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.topConstraint?.isActive = false
            self.bottomConstraint?.isActive = true
            self.blurVisualEffectView.alpha = 1
            self.view.layoutIfNeeded()
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
