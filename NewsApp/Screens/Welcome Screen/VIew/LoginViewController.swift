//
//  LoginViewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel = LoginControllerViewModel()
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private let alertView = VerificationAlertView()
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
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
        let textField = UITextField(placeholder: "user@gmail.com")
        textField.autocapitalizationType = .words
        textField.returnKeyType = .continue
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField(placeholder: "******")
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
        rememberSwitch.addTarget(self, action: #selector(observeRememberSwitch), for: .valueChanged)
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
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.reloadUser()
        updateControllerWithVIewModel()
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = .label

        setupStackView()
        setupDoneButton()

        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0

        setupVerificationAlertView()
    }

    // MARK: - setup user interface methods
    // MARK: -
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
        stackView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: DefaultParameters.buttonWidth, height: 300))
        stackView.centerInSuperview()

        view.addSubview(sigInLabel)
        sigInLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: stackView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 50, right: 50), size: .init(width: 0, height: 50))
    }

    private func setupDoneButton() {
        view.addSubview(letsGoButton)
        letsGoButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 50, right: 0), size: .init(width: DefaultParameters.buttonWidth, height: DefaultParameters.buttonHeight))
        letsGoButton.centerXInSuperview()
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

        alertView.tapHandler = { [weak self] in
            self?.viewModel.reloadUser()
            self?.hideAlertView()
        }
    }

    //MARK: - Actions methods
    //MARK: -
    @objc func cancelButonPressed() {
        dismiss(animated: true, completion: nil)
        viewModel.cancelButonPressed()
    }

    @objc func letsGoButonPressed() {
        validateCredentials()
    }

    @objc private func observeRememberSwitch() {
        NotificationCenter.default.post(name: NSNotification.Name("loginSwitch"), object: rememberSwitch)
    }

    //MARK: - login methods
    //MARK: -
    private func updateControllerWithVIewModel() {
        viewModel.result.bind { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .emptyField :
                self.presentOneButtonAlert(withTitle: "Empty field", message: "Please enter user data")
            case .presentTabBarController:
                self.presentBaseTabBarController()
            case .showAlertView:
                self.showAlertView()
            case .wrongUserData:
                self.presentOneButtonAlert(withTitle: "Error", message: "Wrong user data. Please try again")
            default:
                break
            }
        }
    }

    private func validateCredentials() {
        guard let login = loginTextField.text, let password = passwordTextField.text else {
            return
        }
        viewModel.validateCredentials(with: login, password: password)
    }

    //MARK: - alertView animation methods
    //MARK: -
    private func hideAlertView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.topConstraint?.isActive = true
            self.bottomConstraint?.isActive = false
            self.blurVisualEffectView.alpha = 0
            self.view.layoutIfNeeded()
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
