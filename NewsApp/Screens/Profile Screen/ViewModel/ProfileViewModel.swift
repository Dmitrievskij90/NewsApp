//
//  ProfileVIewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 18.01.2022.
//

import Firebase
import FirebaseAuth
import Foundation
import KeychainAccess

class ProfileViewModel {
    var image = UIImage(named: "imagePlaceholder")
    var user = User()
    var sections = DefaultParameters.sections
    var indexPath: Box<IndexPath?> = Box(nil)
    var result: Box<ProfileResult?> = Box(nil)
    var updateWithUser: ((User) -> Void)?

    init() {
        NotificationCenter.default.post(name: NSNotification.Name("user"), object: user)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUserName),
            name: Notification.Name("profileName"),
            object: nil)
    }

    func loadUserSettings() {
        self.image = AppSettingsManager.shared.loadUserImage()
        self.user = AppSettingsManager.shared.loadUser()
    }

    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        AppSettingsManager.shared.forgetUser()
        self.result.value = .presentWelcomeController
    }

    func didSelectRowAt(indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
                self.indexPath.value = indexPath
            } else {
                let country = sections[indexPath.section].options[indexPath.row - 1]
                switch country {
                case "USA":
                    user.country = "us"
                case "RUSSIA":
                    user.country = "ru"
                case "FRANCE":
                    user.country = "fr"
                case "GERMANY":
                    user.country = "de"
                default:
                    user.country = "us"
                }
                self.updateWithUser?(user)
                sections[indexPath.section].isOpened = false
                self.indexPath.value = indexPath
                AppSettingsManager.shared.saveUser(with: user)
            }
        } else if indexPath.section == 1 {
            self.result.value = .presentCategoriesViewController
        } else {
            self.result.value = .presentStockCompaniesViewController
        }
    }

    func saveUserImage(image: UIImage) {
        AppSettingsManager.shared.saveUserImage(image: image)
    }

    @objc private func updateUserName(_ notification: Notification) {
        if let name = notification.object as? String {
            if name.isEmpty {
                user.name = "Reader"
            } else {
                user.name = name
            }
            AppSettingsManager.shared.saveUser(with: user)
        }
    }
}
