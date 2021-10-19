//
//  RegisterController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.09.2021.
//

import UIKit
import KeychainAccess

class RegisterController: UIViewController {
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
        textField.autocapitalizationType = .words
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
        textField.autocapitalizationType = .words
        textField.returnKeyType = .continue
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        let attributedString = NSAttributedString(string: "Repeat password", attributes: attributes)
        textField.attributedPlaceholder = attributedString
        textField.constrainHeight(constant: 50)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .lightGray
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
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
    
    let doneButton: BaseButton = {
        let button = BaseButton(type: .system)
        button.setTitle("Done", for: .normal)
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
        repeatPasswordTextField.delegate = self
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
            repeatPasswordTextField,
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
            AppSettingsManager.shared.setUserCredentials(login: login, password: password)
            presentBaseTabBarController()
        }
    }
    
    private func presentBaseTabBarController() {
        let dV = BaseTabBarController()
        dV.modalPresentationStyle = .fullScreen
        present(dV, animated: true, completion: nil)
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
