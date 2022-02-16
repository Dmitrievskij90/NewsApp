//
//  RegisterController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.09.2021.
//

import UIKit

class RegisterController: UIViewController {
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
    private let confirmLabel = UILabel(text: "Confirm password")
    private let viewModel = RegisterControllerViewModel()
    
    private let registerLabel: UILabel = {
        let label = UILabel(text: "Register your new account", font: .boldSystemFont(ofSize: 25), textColor: .black)
        label.textAlignment = .center
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
        textField.returnKeyType = .continue
        textField.isSecureTextEntry = true
        return textField
    }()
    private let repeatPasswordTextField: UITextField = {
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
    private let doneButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.createGraphiteButton(title: "Done")
        button.addTarget(self, action: #selector(doneButonPressed), for: .touchUpInside)
        return button
    }()

    private let closeButton: CloseButton = {
        let button = CloseButton(type: .system)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self

        updateControllerWithVIewModel()
    }
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        setupStackView()
        setupDoneButton()
        setupCloseButton()
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

        let confirmPasswordStackView = UIStackView(arrangedSubviews: [
            confirmLabel,
            repeatPasswordTextField
        ])
        confirmPasswordStackView.axis = .vertical
        confirmPasswordStackView.spacing = 4

        let stackView = UIStackView(arrangedSubviews: [
            emailStackView,
            passwordStackView,
            confirmPasswordStackView,
            keepMeSignedInStackView
        ])

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing

        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: DefaultParameters.buttonWidth, height: 300))
        stackView.centerInSuperview()

        view.addSubview(registerLabel)
        registerLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: stackView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 50, right: 50), size: .init(width: 0, height: 50))
    }

    private func setupDoneButton() {
        view.addSubview(doneButton)
        doneButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 50, right: 0), size: .init(width: DefaultParameters.buttonWidth, height: DefaultParameters.buttonHeight))
        doneButton.centerXInSuperview()
    }

    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
    }

    @objc private func doneButonPressed() {
        setUserData()
    }

    @objc func handleDismiss() {
        viewModel.cancelButonPressed()
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func observeRememberSwitch() {
        NotificationCenter.default.post(name: NSNotification.Name("rememberSwitch"), object: rememberSwitch)
    }

    private func updateControllerWithVIewModel() {
        viewModel.result.bind { [weak self ] result in
            guard let self = self else {
                return
            }
            switch result {
            case .emptyField :
                self.presentOneButtonAlert(withTitle: "Empty field", message: "Please enter user data")
            case .badEmailFormat:
                self.presentOneButtonAlert(withTitle: "Incorrect Email format", message: "")
            case .passwordsNotmatch:
                self.presentOneButtonAlert(withTitle: "Passwords don't match", message: "Please check the spelling and try again")
            case .registrationFailed:
                self.presentOneButtonAlert(withTitle: "Registration failed", message: "Please try later")
            case .userAlredyExists:
                self.presentOneButtonAlert(withTitle: "User is alredy exists", message: "")
            case .shortPassword:
                self.presentOneButtonAlert(withTitle: "Short password", message: "The password must be equal to or greater than 6 characters")
            case .presentVerificationController:
                self.presentVerificationController()
            default:
                break
            }
        }
    }

    private func setUserData() {
        guard let login = loginTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else {
            return
        }
        viewModel.setUserData(with: login, password: password, repeatPassword: repeatPassword)
    }

    private func presentVerificationController() {
        let destinationVC = VerificationController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if loginTextField.text == "" || passwordTextField.text == "" || repeatPasswordTextField.text == "" {
            rememberSwitch.isUserInteractionEnabled = false
        } else {
            rememberSwitch.isUserInteractionEnabled = true
        }
    }
}
