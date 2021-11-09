//
//  KeychainManager.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 13.09.2021.
//

import Foundation
import KeychainAccess

class AppSettingsManager {
    static let shared = AppSettingsManager()
    private let defaults = UserDefaults.standard

    var notFirsAppLaunch = UserDefaults.standard.bool(forKey: "isTrue")

    var country: String {
        let country = defaults.value(forKey: "chosenCountry") as? String ?? "us"
        return country
    }

    var userLogin: String {
        guard let userLogin = try? keychain.get("login") else {
            fatalError("the user's login is not set")
        }
        return userLogin
    }

    var userPassword: String {
        guard let userPassword = try? keychain.get("password") else {
            fatalError("the user's password is not set")
        }
        return userPassword
    }

    var isUserSignedIn: String {
        guard let rememberUser = try? keychain.get("remember") else {
            return ""
        }
        return rememberUser
    }

    private let keychain = Keychain()

    func keepUserSignedIn() {
        keychain["remember"] = "yes"
    }

    func forgetUser() {
        keychain["remember"] = nil
    }

    func setUserCredentials(login: String, password: String) {
        keychain["login"] = login
        keychain["password"] = password
    }
}
