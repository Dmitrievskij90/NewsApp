//
//  KeychainManager.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 13.09.2021.
//

import Foundation
import KeychainAccess

class KeychainManager {
    static let shared = KeychainManager()

    var userLogin: String {
        guard let userPassword = try? keychain.get("login") else {
            fatalError("the user's login is not set")
        }
        return userPassword
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

    func setUserCredentials(login: String, password: String) {
        keychain["login"] = login
        keychain["password"] = password
    }
}
