//
//  ProfileVIewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit
import KeychainAccess

class ProfileViewController: UIViewController {
    private let keychain = Keychain()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
        tableView.register(ChooseCountryCell.self, forCellReuseIdentifier: ChooseCountryCell.identifier)
        tableView.register(ProfileTableHeader.self, forHeaderFooterViewReuseIdentifier: ProfileTableHeader.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()

    private var sections = [CountrySection]()

    private let exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("LOG OUT", for: .normal)
        button.contentMode = .center
        button.backgroundColor = .init(hex: 0xBE1FBB)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(exitButonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            CountrySection(title: "Choose country",
                     countries: ["USA", "RUSSIA", "FRANCE"],
                     countriesImages: ["usa_image", "russia_image", "france_image"])
        ]
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.backgroundColor = .gray

        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 100, right: 0))
        
        view.addSubview(exitButton)
        exitButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 100, right: 0), size: .init(width: 100, height: 50))
        exitButton.centerXInSuperview()
    }

    @objc func exitButonPressed() {
        keychain["remember"] = nil

        let destinationVC = WelcomeController()
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }

    private func displayImagePickerController() {
        let imagePicerController = UIImagePickerController()
        imagePicerController.delegate = self
        imagePicerController.sourceType = .photoLibrary
        present(imagePicerController, animated: true, completion: nil)
    }
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return section.countries.count + 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCountryCell.identifier, for: indexPath) as? ChooseCountryCell else {
                return UITableViewCell()
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        cell.countryLabel.text = sections[indexPath.section].countries[indexPath.row - 1]
        cell.countryImageView.image = UIImage(named: sections[indexPath.section].countriesImages[indexPath.row - 1])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            let country = sections[indexPath.section].countries[indexPath.row - 1]
            switch country {
            case "USA":
                UserDefaults.standard.setValue("us", forKey: "chosenCountry")
            case "RUSSIA":
                UserDefaults.standard.setValue("ru", forKey: "chosenCountry")
            case "FRANCE":
                UserDefaults.standard.setValue("fr", forKey: "chosenCountry")
            default:
                UserDefaults.standard.setValue("us", forKey: "chosenCountry")
            }

            let countryImage = sections[indexPath.section].countriesImages[indexPath.row - 1]
            UserDefaults.standard.setValue(countryImage, forKey: "countryImage")

            sections[indexPath.section].isOpened = false
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileTableHeader.identifier) as? ProfileTableHeader else {
            return UIView()
        }
        header.helloLabel.text = "Hello,\(KeychainManager.shared.userLogin)!"
        header.userImageView.image = image
        header.imageTapHandler = { [unowned self] in
            self.displayImagePickerController()
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}
