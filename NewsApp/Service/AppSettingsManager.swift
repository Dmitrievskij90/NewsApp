//
//  KeychainManager.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 13.09.2021.
//

import FirebaseAuth
import Foundation
import KeychainAccess

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

    // MARK: - User settings data manipulation methods
    // MARK: -
    func keepUserSignedIn() {
        keychain["remember"] = "yes"
    }

    func forgetUser() {
        keychain["remember"] = nil
    }

    func saveUserImage(image: UIImage) {
        guard let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            return
        }
        if FileManager.default.fileExists(atPath: documentsPath.path) == false {
            do {
                try FileManager.default.createDirectory(atPath: documentsPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Can't save image to directory")
            }
        }
        let data = image.jpegData(compressionQuality: 0.5)
        let imageName = "userImage.png"
        FileManager.default.createFile(atPath: "\(documentsPath.path)/\(imageName)", contents: data, attributes: nil)
    }

    func loadUserImage() -> UIImage? {
        var image = UIImage()
        guard let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            fatalError("Can't find directory path")}
        if let imageName = try? FileManager.default.contentsOfDirectory(atPath: "\(documentsPath.path)")[0] {
            if let loadedImage = UIImage(contentsOfFile: "\(documentsPath.path)/\(imageName)") {
                image = loadedImage
            }
        } else {
            image = UIImage(named: "imagePlaceholder") ?? UIImage()
        }
        return image
    }

    func saveUser(with user: User) {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            return
        }
        try? FileManager.default.createDirectory(at: documentDirectoryPath, withIntermediateDirectories: false, attributes: nil)
        let data = try? JSONEncoder().encode(user)
        let dataPath = documentDirectoryPath.appendingPathComponent("user.json")
        FileManager.default.createFile(atPath: dataPath.path, contents: data, attributes: nil)
    }

    func loadUser() -> User {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            fatalError("Can't find directory path")}
        var user: User?
        let dataPath = documentDirectoryPath.appendingPathComponent("user.json")
        if let newData = FileManager.default.contents(atPath: dataPath.path) {
            user = try? JSONDecoder().decode(User.self, from: newData)
        }
        return user ?? User()
    }
}
