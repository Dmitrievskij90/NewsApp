//
//  KeychainManager.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 13.09.2021.
//

import Foundation
import KeychainAccess
import FirebaseAuth

class AppSettingsManager {
    static let shared = AppSettingsManager()
    private let defaults = UserDefaults.standard
    private let keychain = Keychain()

    var notFirsAppLaunch = UserDefaults.standard.bool(forKey: "isTrue")

    var country: String {
        let country = defaults.value(forKey: "chosenCountry") as? String ?? "us"
        return country
    }

    var userLogin: String {
        var login = ""
        let user = Auth.auth().currentUser
        if let user = user {
            if let email = user.email {
                login = email
            }

        }
        return login
    }

    var isUserSignedIn: String {
        guard let rememberUser = try? keychain.get("remember") else {
            return ""
        }
        return rememberUser
    }

    func keepUserSignedIn() {
        keychain["remember"] = "yes"
    }

    func forgetUser() {
        keychain["remember"] = nil
    }
}
