//
//  LoginViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private let alertView = VerificationAlertView()
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let emailLabel = UILabel()
    private let passwordLabel = UILabel()
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
        textField.autocapitalizationType = .words
        textField.returnKeyType = .continue
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
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
        button.setTitleColor(.init(hex: 0x4EFDD), for: .normal)
        button.backgroundColor = .init(hex: 0x494d4e)
        button.addTarget(self, action: #selector(letsGoButonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTextField.delegate = self

        guard let user = Auth.auth().currentUser else {
            return
        }
        user.reload { error in
        }
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = .label

        setupTextFields(with: loginTextField, text: "user@gmail.com")
        setupTextFields(with: passwordTextField, text: "******")

        setupStackViewLabels(with: emailLabel, text: "Email")
        setupStackViewLabels(with: passwordLabel, text: "Password")

        setupStackView()
        setupDoneButton()

        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0

        setupVerificationAlertView()
    }

    // MARK: - setup user interface methods
    // MARK: -
    private func setupTextFields(with textField: UITextField, text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font : UIFont.systemFont(ofSize: 10)
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        textField.attributedPlaceholder = attributedString
        textField.constrainHeight(constant: 50)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowRadius = 10
        textField.layer.shadowOffset = .init(width: 0, height: 10)
        textField.layer.shadowColor = UIColor.darkGray.cgColor
    }

    private func setupStackViewLabels(with label: UILabel, text: String) {
        label.text = text
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }

    private func setupStackView() {
        let keepMeSignedInStackView = UIStackView(arrangedSubviews: [
            rememberSwitch,
            keepMeSignedInLabel
        ])
        keepMeSignedInStackView.axis = .vertical
        keepMeSignedInStackView.spacing = 4

        let emailStackView = UIStackView(arrangedSubviews: [
            emailLabel,
            loginTextField
        ])
        emailStackView.axis = .vertical
        emailStackView.spacing = 4

        let passwordStackView = UIStackView(arrangedSubviews: [
            passwordLabel,
            passwordTextField
        ])
        passwordStackView.axis = .vertical
        passwordStackView.spacing = 4

        let stackView = UIStackView(arrangedSubviews: [
            emailStackView,
            passwordStackView,
            keepMeSignedInStackView
        ])

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing

        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50), size: .init(width: 0, height: 300))
        stackView.centerInSuperview()

        view.addSubview(sigInLabel)
        sigInLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: stackView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 50, right: 50), size: .init(width: 0, height: 50))
    }

    private func setupDoneButton() {
        view.addSubview(letsGoButton)
        letsGoButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 50, right: 50), size: .init(width: 0, height: 50))
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

    @objc func cancelButonPressed() {
        dismiss(animated: true, completion: nil)
        AppSettingsManager.shared.forgetUser()
    }

    @objc func letsGoButonPressed() {
        validateCredentials()
    }

    private func validateCredentials() {

        guard let login = loginTextField.text else {
            fatalError("Wrong login")
        }
        guard let password = passwordTextField.text else {
            fatalError("Wrong password")
        }

        if login.isEmpty || password.isEmpty {
            presentOneButtonAlert(withTitle: "Empty field", message: "Please enter user data")
        } else {
            Auth.auth().signIn(withEmail: login, password: password) { (authResult, error) in
                if let authResult = authResult {
                    let user = authResult.user
                    if user.isEmailVerified {
                        if self.rememberSwitch.isOn {
                            AppSettingsManager.shared.keepUserSignedIn()
                        }
                        self.presentBaseTabBarController()
                    } else {
                        self.showAlertView()
                    }
                }
                if error != nil {
                    self.presentOneButtonAlert(withTitle: "Error", message: "Wrong user data. Please try again")
                }
            }
        }
    }

    private func showAlertView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.topConstraint?.isActive = false
            self.bottomConstraint?.isActive = true
            self.blurVisualEffectView.alpha = 1
            self.view.layoutIfNeeded()
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
