//
//  LoginControllerViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 26.12.2021.
//

import Firebase
import FirebaseAuth
import Foundation

class LoginControllerViewModel {
    var result: Box<LoginResult?> = Box(nil)
    private var isSwitchOn = false

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBoll),
            name: Notification.Name("loginSwitch"),
            object: nil)
    }

    func cancelButonPressed() {
        AppSettingsManager.shared.forgetUser()
    }

    func reloadUser() {
        Auth.auth().currentUser?.reload()
    }

    func validateCredentials(with login: String, password: String) {
        if login.isEmpty || password.isEmpty {
            self.result.value = .emptyField
        } else {
            Auth.auth().signIn(withEmail: login, password: password) { [weak self] authResult, error in
                guard let self = self else {
                    return
                }
                if let authResult = authResult {
                    let user = authResult.user
                    if user.isEmailVerified {
                        self.keepUserSignedIn()
                        self.saveUserSettings()
                        self.result.value = .presentTabBarController
                    } else {
                        self.result.value = .showAlertView
                    }
                }
                if error != nil {
                    self.result.value = .wrongUserData
                }
            }
        }
    }

    private func keepUserSignedIn() {
        if isSwitchOn {
            AppSettingsManager.shared.keepUserSignedIn()
        }
    }

    private func saveUserSettings() {
        CategoryManager.shared.isFirstLoad {
            CategoryManager.shared.saveCategoriesSet(with: DefaultParameters.categoriesSet)
            CategoryManager.shared.saveCategoriesStruct(with: DefaultParameters.categoriesStruct)
            CategoryManager.shared.saveStockCompaniesSet(with: DefaultParameters.stockCompaniesSet)
            CategoryManager.shared.saveStockCompaniesStruct(with: DefaultParameters.stockCompaniesStruct)
            AppSettingsManager.shared.saveUser(with: DefaultParameters.user)
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
