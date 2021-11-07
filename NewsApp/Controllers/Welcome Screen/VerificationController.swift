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

    private let letsGoButton: UIButton = {
        let button = BaseButton(type: .system)
        button.setTitle("Let's go", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(hex: 0x16697A)
        button.addTarget(self, action: #selector(doneButonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = .label

        Auth.auth().currentUser?.reload()

        view.addSubview(letsGoButton)
        letsGoButton.centerInSuperview(size: .init(width: 100, height: 50))
    }

    @objc func cancelButonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc func doneButonPressed() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        user.reload { _ in
            switch user.isEmailVerified {
            case true:
                self.presentBaseTabBarController()
            case false:
                self.presentRegisterAlert()
            }
        }
    }

    func presentRegisterAlert() {
        let alertController = UIAlertController(title: "Virify you account", message: "We sent verification email to you. Please verify and tap DONE button again", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            Auth.auth().currentUser?.reload()

            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }

    private func presentBaseTabBarController() {
        let dV = BaseTabBarController()
        dV.modalPresentationStyle = .fullScreen
        present(dV, animated: true, completion: nil)
    }
}
