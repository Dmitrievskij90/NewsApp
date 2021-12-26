//
//  RegisterControllerViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 22.12.2021.
//

import Foundation
import Firebase
import FirebaseAuth

class RegisterControllerViewModel {
    var result: Box<RegisterResult?> = Box(nil)
    private var isSwitchOn = false

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBoll),
            name: Notification.Name("rememberSwitch"),
            object: nil)
    }

    func cancelButonPressed() {
        AppSettingsManager.shared.forgetUser()
    }

    func setUserData(with login: String, password: String, repeatPassword: String) {
        if isSwitchOn {
            AppSettingsManager.shared.keepUserSignedIn()
        }
        if login.isEmpty || password.isEmpty {
            self.result.value = .emptyField
        } else if password.count < 6 || repeatPassword.count < 6 {
            self.result.value = .shortPassword
        } else if password != repeatPassword {
            self.result.value = .passwordsNotmatch
        } else {
            fetchSignInMethod(with: login, password: password)
        }
    }

    private func fetchSignInMethod(with login: String, password: String) {
        Auth.auth().fetchSignInMethods(forEmail: login, completion: { [weak self] (providers, error) in
            guard let self = self else {
                return
            }
            if error != nil  {
                self.result.value = .badEmailFormat
            } else if providers != nil {
                self.result.value = .userAlredyExists
            } else {
                self.createUser(with: login, password: password)
                self.result.value = .presentVerificationController
                //                    self.presentVerificationController()
            }
        })
    }

    private func createUser(with login: String, password: String) {
        Auth.auth().createUser(withEmail: login, password: password) { [weak self] (authDataResult, error) in
            guard let self = self else {
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
                self.result.value = .registrationFailed
            }
        }
    }

    @objc private func updateBoll(_ notification: Notification) {
        if let registerSwitch = notification.object as? UISwitch {
            if registerSwitch.isOn {
                isSwitchOn = true
            }
        }
    }
}

