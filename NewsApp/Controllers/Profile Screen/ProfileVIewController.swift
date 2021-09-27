//
//  ProfileVIewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit
import KeychainAccess

class ProfileViewController: UIViewController {
    private let fileManager = FileManager.default
    private let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(KeychainManager.shared.userLogin)
    private let keychain = Keychain()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
        tableView.register(ChooseCountryCell.self, forCellReuseIdentifier: ChooseCountryCell.identifier)
        tableView.register(ProfileTableHeader.self, forHeaderFooterViewReuseIdentifier: ProfileTableHeader.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()
    private let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("LOG OUT", for: .normal)
        button.contentMode = .center
        button.backgroundColor = .init(hex: 0xBE1FBB)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(exitButonPressed), for: .touchUpInside)
        return button
    }()

    private var image = UIImage(named: "news_image")
    private var sections = [CountrySection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [CountrySection(
                        title: "Choose country",
                        countries: ["USA", "RUSSIA", "FRANCE", "GERMANY"],
                        countriesImages: ["usa_image", "russia_image", "france_image", "germany_image"])
        ]

        loadUserImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - setup user interface methods
    // MARK: -
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.backgroundColor = .gray

        setupTableView()
        setupFooterForTableView()
        setupLogOutButton()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.frame.width, height: view.frame.height))
    }

    private func setupFooterForTableView() {
        let footer = ProfileTableFooter()
        footer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        footer.transitionHandler = {
            let viewController = CategoriesViewController()
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        self.tableView.tableFooterView = footer
    }

    private func setupLogOutButton() {
        view.addSubview(logOutButton)
        logOutButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 100, right: 0), size: .init(width: 100, height: 50))
        logOutButton.centerXInSuperview()
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

    private func loadUserImage() {
        guard let path = documentsPath?.path else {
            fatalError("Can't find document path")
        }
        if let imageName = try? fileManager.contentsOfDirectory(atPath: "\(path)")[0] {
            if let loadedImage = UIImage(contentsOfFile: "\(path)/\(imageName)") {
                self.image = loadedImage
            }
        }
    }
}

//MARK: - UITableViewDataSource and UITableViewDelegate methods
//MARK: -
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
            case "GERMANY":
                UserDefaults.standard.setValue("de", forKey: "chosenCountry")
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

//MARK: - UIImagePickerControllerDelegate methods
//MARK: -
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let path = documentsPath?.path else {
            fatalError("Can't find document path")
        }

        if let image = info [.originalImage] as? UIImage {
            self.image = image
            tableView.reloadData()

            if fileManager.fileExists(atPath: path) == false {
                do {
                    try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    fatalError("Can't save image to directory")
                }
            }
            let data = image.jpegData(compressionQuality: 0.5)
            let imageName = "userImage.png"
            fileManager.createFile(atPath: "\(path)/\(imageName)", contents: data, attributes: nil)

        } else {
            fatalError("Can't find image")
        }
        dismiss(animated: true, completion: nil)
    }
}

