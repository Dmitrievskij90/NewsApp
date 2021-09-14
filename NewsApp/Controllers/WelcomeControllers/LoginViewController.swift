//
//  LoginViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit

class LoginViewController: UIViewController {

    private let loginTextField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        let attributedString = NSAttributedString(string: "Login", attributes: attributes)
        textField.attributedPlaceholder = attributedString
        textField.constrainHeight(constant: 50)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .lightGray
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.returnKeyType = .continue
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        let attributedString = NSAttributedString(string: "Password", attributes: attributes)
        textField.attributedPlaceholder = attributedString
        textField.constrainHeight(constant: 50)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .lightGray
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.returnKeyType = .continue
        textField.isSecureTextEntry = true
        return textField
    }()

    private let rememberSwitch: UISwitch = {
        let rememberSwitch = UISwitch()
        rememberSwitch.isOn = false
        rememberSwitch.onTintColor = .init(hex: 0xBE1FBB)
        rememberSwitch.thumbTintColor = .white
        return rememberSwitch
    }()

    private let keepMeSignedInLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep me signed in"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()

    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Let's go", for: .normal)
        button.contentMode = .center
        button.backgroundColor = .init(hex: 0xBE1FBB)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = .label

        let keepMeSignedInStackView = UIStackView(arrangedSubviews: [
            rememberSwitch,
            keepMeSignedInLabel
        ])
        keepMeSignedInStackView.axis = .vertical
        keepMeSignedInStackView.spacing = 4

        let stackView = UIStackView(arrangedSubviews: [
            loginTextField,
            passwordTextField,
            keepMeSignedInStackView
        ])

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing

        view.addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 300, height: 400), constantY: -50)

        view.addSubview(doneButton)
        doneButton.anchor(top: stackView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 50))
        doneButton.centerXInSuperview()
    }

    @objc func cancelButonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc func doneButonPressed() {
        validateCredentials()
    }

    private func validateCredentials() {
        guard let login = loginTextField.text else {
            fatalError("Wrong login")
        }
        guard let password = passwordTextField.text else {
            fatalError("Wrong password")
        }

        if rememberSwitch.isOn {
            KeychainManager.shared.keepUserSignedIn()
        }

        if KeychainManager.shared.userLogin == login, KeychainManager.shared.userPassword == password {
            presentBaseTabBarController()
        } else {
            presentOneButtonAlert(withTitle: "Error", message: "Wrong user data. Please try again")
        }
    }

    private func presentBaseTabBarController() {
        let dV = BaseTabBarController()
        dV.modalPresentationStyle = .fullScreen
        present(dV, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
