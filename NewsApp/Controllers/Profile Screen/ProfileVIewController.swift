//
//  ProfileVIewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit
import KeychainAccess
import Firebase

class ProfileViewController: UIViewController {
    private let fileManager = FileManager.default
    private let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
    private let keychain = Keychain()
    private var image = UIImage(named: "news_image")
    private var sections = [CountrySection]()
    private var header = ProfileTableHeader()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
        tableView.register(ChooseCountryCell.self, forCellReuseIdentifier: ChooseCountryCell.identifier)
        tableView.register(FavouriteCategoriesCell.self, forCellReuseIdentifier: FavouriteCategoriesCell.identifier)
        tableView.register(StockCompaniesCell.self, forCellReuseIdentifier: StockCompaniesCell.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [CountrySection(
                        options: ["USA", "RUSSIA", "FRANCE", "GERMANY"],
                        countriesImages: ["usa_image", "russia_image", "france_image", "germany_image"]),
                    CountrySection(
                        options: [],
                        countriesImages: []),
                    CountrySection(
                        options: [],
                        countriesImages: []),
        ]

        loadUserImage()
        setupHeaderForTableView()
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
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black

        setupTableView()
        setupFooterForTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.frame.width, height: view.frame.height))
    }

    private func setupHeaderForTableView() {
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.frame.height / 4 )
        header.helloLabel.text = "Hello,\(AppSettingsManager.shared.userLogin)!"
        header.userImageView.image = image
        header.imageTapHandler = { [unowned self] in
            self.displayImagePickerController()
        }
        self.tableView.tableHeaderView = header
    }

    private func setupFooterForTableView() {
        let footer = ProfileTableFooter()
        footer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100 )
        footer.transitionHandler = {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            self.keychain["remember"] = nil
            let destinationVC = WelcomeController()
            destinationVC.modalPresentationStyle = .fullScreen
            self.present(destinationVC, animated: true, completion: nil)
        }
        self.tableView.tableFooterView = footer
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
            return section.options.count + 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCountryCell.identifier, for: indexPath) as? ChooseCountryCell else {
                    return UITableViewCell()
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else {
                    return UITableViewCell()
                }
                cell.countryLabel.text = sections[indexPath.section].options[indexPath.row - 1]
                cell.countryImageView.image = UIImage(named: sections[indexPath.section].countriesImages[indexPath.row - 1])
                return cell
            }
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCategoriesCell.identifier, for: indexPath) as? FavouriteCategoriesCell else {
                return UITableViewCell()
            }
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCompaniesCell.identifier, for: indexPath) as? StockCompaniesCell else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
                tableView.reloadSections([indexPath.section], with: .none)
            } else {
                let country = sections[indexPath.section].options[indexPath.row - 1]
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
                header.countryImageView.image = UIImage(named: countryImage)
                UserDefaults.standard.setValue(countryImage, forKey: "countryImage")
                sections[indexPath.section].isOpened = false
                tableView.reloadSections([indexPath.section], with: .none)
            }
        } else if indexPath.section == 1 {
            let viewController = CategoriesViewController()
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = StockCompaniesViewController()
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate methods
//MARK: -
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let path = documentsPath?.path else {
            fatalError("Can't find document path")
        }

        if let image = info[.originalImage] as? UIImage {
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
        header.userImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

