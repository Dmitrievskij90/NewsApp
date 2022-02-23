//
//  VerificationControllerViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 10.01.2022.
//

import Firebase
import FirebaseAuth
import Foundation

class VerificationControllerViewModel {
    var result: Box<VerificationResult?> = Box(nil)
    private var user = User()

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUserCountry),
            name: Notification.Name("country"),
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUserName),
            name: Notification.Name("name"),
            object: nil)
    }

    func cancelButonPressed() {
        AppSettingsManager.shared.forgetUser()
    }

    func reloadUser() {
        Auth.auth().currentUser?.reload()
    }

    func letsGoButonPressed() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        user.reload { [weak self] _ in
            guard let self = self else {
                return }
            switch user.isEmailVerified {
            case true:
                self.saveUserSettings()
                self.result.value = .presentTabBarController
            case false:
                self.result.value = .showAlertView
            }
        }
    }

    func saveUserImage(image: UIImage) {
        AppSettingsManager.shared.saveUserImage(image: image)
    }

    @objc private func updateUserCountry(_ notification: Notification) {
        if let tag = notification.object as? Int {
            switch tag {
            case 1:
                user.country = "ru"
            case 2:
                user.country = "us"
            case 3:
                user.country = "fr"

            case 4:
                user.country = "de"
            default:
                user.country = "us"
            }
        }
    }

    @objc private func updateUserName(_ notification: Notification) {
        if let name = notification.object as? String {
            user.name = name
        }
    }

    private func saveUserSettings() {
        CategoryManager.shared.saveCategoriesSet(with: DefaultParameters.categoriesSet)
        CategoryManager.shared.saveCategoriesStruct(with: DefaultParameters.categoriesStruct)
        CategoryManager.shared.saveStockCompaniesSet(with: DefaultParameters.stockCompaniesSet)
        CategoryManager.shared.saveStockCompaniesStruct(with: DefaultParameters.stockCompaniesStruct)
        AppSettingsManager.shared.saveUser(with: user)
    }
}
