//
//  WelcomeControllerViewModel.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 22.12.2021.
//

import Foundation
import KeychainAccess

class WelcomeControllerViewModel {
    private let keychain = Keychain()
    private let defaults = UserDefaults.standard

    init() {
        validateIsItFirstAppLaunch()
    }

    func validateIsItFirstAppLaunch() {
        if !AppSettingsManager.shared.notFirsAppLaunch {
            keychain["remember"] = nil
            defaults.setValue(true, forKey: "isTrue")
        }
    }
}
