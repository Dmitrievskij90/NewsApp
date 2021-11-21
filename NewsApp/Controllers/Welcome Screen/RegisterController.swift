//
//  RegisterController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.09.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterController: UIViewController {
    private let emailLabel = UILabel()
    private let passwordLabel = UILabel()
    private let confirmLabel = UILabel()

    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Register your new account"
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
        textField.constrainHeight(constant: DefaultParameters.buttonHeight)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .continue
        textField.isSecureTextEntry = true
        textField.constrainHeight(constant: DefaultParameters.buttonHeight)
        return textField
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.constrainHeight(constant: DefaultParameters.buttonHeight)
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
    
    private let doneButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.init(hex: 0x4EFDD), for: .normal)
        button.backgroundColor = .init(hex: 0x494d4e)
        button.addTarget(self, action: #selector(doneButonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
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
        setupTextFields(with: repeatPasswordTextField, text: "******")

        setupStackViewLabels(with: emailLabel, text: "Email")
        setupStackViewLabels(with: passwordLabel, text: "Password")
        setupStackViewLabels(with: confirmLabel, text: "Confirm password")

        setupStackView()
        setupDoneButton()
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
    
    @objc func cancelButonPressed() {
        dismiss(animated: true, completion: nil)
        AppSettingsManager.shared.forgetUser()
    }

    @objc func doneButonPressed() {
        setUserData()
    }

    private func setUserData() {
        guard let login = loginTextField.text else {
            fatalError("Wrong login")
        }
        guard let password = passwordTextField.text else {
            fatalError("Wrong password")
        }
        
        guard let repeatPassword = repeatPasswordTextField.text else {
            fatalError("Wrong password")
        }
        
        if rememberSwitch.isOn {
            AppSettingsManager.shared.keepUserSignedIn()
        }
        
        if login.isEmpty || password.isEmpty {
            presentOneButtonAlert(withTitle: "Empty field", message: "Please enter user data")
        } else if password != repeatPassword {
            presentOneButtonAlert(withTitle: "Passwords don't match", message: "Please check the spelling and try again")
        } else {
            Auth.auth().fetchSignInMethods(forEmail: login, completion: {
                (providers, error) in
                if error != nil  {
                    self.presentOneButtonAlert(withTitle: "Bad Email format", message: "")
                } else if providers != nil {
                    self.presentOneButtonAlert(withTitle: "User is alredy exists", message: "")
                } else {
                    self.createUser(with: login, password: password)
                    self.presentVerificationController()
                }
            })
        }
    }

    private func createUser(with login: String, password: String) {
        Auth.auth().createUser(withEmail: login, password: password) { [weak self] (authDataResult, error) in
            guard let strongSelf = self else {
                return
            }
            if let authResult = authDataResult {
                let user = authResult.user
                user.sendEmailVerification { error in
                    if error != nil {
                        print("we have problem \(String(describing: error))")
                    }
                }
            }
            if error != nil {
                strongSelf.presentOneButtonAlert(withTitle: "Registration failed", message: "Please try later")
            }
        }
    }

    private func presentVerificationController() {
        let destinationVC = VerificationController()
        let navVC = UINavigationController(rootViewController: destinationVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
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
