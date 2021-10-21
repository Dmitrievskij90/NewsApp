//
//  LoginViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit

class LoginViewController: UIViewController {
    private let sigInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to your account"
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private let loginTextField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray
        ]
        let attributedString = NSAttributedString(string: "Login", attributes: attributes)
        textField.attributedPlaceholder = attributedString
        textField.constrainHeight(constant: 50)
        textField.borderStyle = .bezel
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.autocapitalizationType = .words
        textField.returnKeyType = .continue
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray
        ]
        let attributedString = NSAttributedString(string: "Password", attributes: attributes)
        textField.attributedPlaceholder = attributedString
        textField.constrainHeight(constant: 50)
        textField.borderStyle = .bezel
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.returnKeyType = .continue
        textField.isSecureTextEntry = true
        return textField
    }()

    private let rememberSwitch: UISwitch = {
        let rememberSwitch = UISwitch()
        rememberSwitch.isOn = false
        rememberSwitch.onTintColor = .init(hex: 0xDB6400)
        rememberSwitch.thumbTintColor = .white
        rememberSwitch.isUserInteractionEnabled = false
        return rememberSwitch
    }()

    private let keepMeSignedInLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep me signed in"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()

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
            sigInLabel,
            loginTextField,
            passwordTextField,
            keepMeSignedInStackView
        ])

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing

        view.addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 300, height: 400), constantY: -50)

        view.addSubview(letsGoButton)
        letsGoButton.anchor(top: stackView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 50))
        letsGoButton.centerXInSuperview()
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

        if AppSettingsManager.shared.userLogin == login, AppSettingsManager.shared.userPassword == password {
            if rememberSwitch.isOn {
                AppSettingsManager.shared.keepUserSignedIn()
            }
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

    func textFieldDidEndEditing(_ textField: UITextField) {
        if loginTextField.text == "" || passwordTextField.text == "" {
            rememberSwitch.isUserInteractionEnabled = false
        } else {
            rememberSwitch.isUserInteractionEnabled = true
        }
    }
}
