//
//  ProfileVIewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 18.01.2022.
//

import Foundation
import KeychainAccess
import Firebase
import FirebaseAuth

class ProfileViewModel {
    var image = UIImage(named: "imagePlaceholder")
    var user = User()
    var sections = DefaultParameters.sections
    var indexPath: Box<IndexPath?> = Box(nil)
    var updateWithUser: ((User)-> Void)?
    var result: Box<ProfileResult?> = Box(nil)

    init() {
        NotificationCenter.default.post(name: NSNotification.Name("user"), object: user)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUserName),
            name: Notification.Name("profileName"),
            object: nil)
    }

    @objc private func updateUserName(_ notification: Notification) {
        if let name = notification.object as? String {
            if name.isEmpty {
                user.name = "Reader"
            } else {
                user.name = name
            }
            CategoryManager.shared.saveUser(with: user)
        }
    }

    func loadUserSettings() {
        self.image = CategoryManager.shared.loadUserImage()
        self.user = CategoryManager.shared.loadUser()
    }

    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
                CategoryManager.shared.saveUser(with: user)
            }
        } else if indexPath.section == 1 {
            self.result.value = .presentCategoriesViewController
        } else {
            self.result.value = .presentStockCompaniesViewController
        }
    }

    func saveUserImage(image: UIImage) {
        CategoryManager.shared.saveUserImage(image: image)
    }
}
