//
//  ProfileVIewController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 14.09.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    private var header = ProfileTableHeader()
    private let viewModel = ProfileViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
        tableView.register(ChooseCountryCell.self, forCellReuseIdentifier: ChooseCountryCell.identifier)
        tableView.register(FavouriteCategoriesCell.self, forCellReuseIdentifier: FavouriteCategoriesCell.identifier)
        tableView.register(StockCompaniesCell.self, forCellReuseIdentifier: StockCompaniesCell.identifier)
        tableView.register(DeleteCell.self, forCellReuseIdentifier: DeleteCell.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadUserSettings()
        updateControllerWithViewModel()
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
        setupHeaderForTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.frame.width, height: view.frame.height))
    }
    
    private func setupHeaderForTableView() {
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.frame.height / 4 )
        header.nameTextField.delegate = self
        header.imageTapHandler = { [weak self] in
            self?.displayImagePickerController()
        }
        self.tableView.tableHeaderView = header
    }
    
    private func setupFooterForTableView() {
        let footer = ProfileTableFooter()
        footer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100 )
        footer.transitionHandler = { [weak self] in
            self?.viewModel.signOut()
        }
        self.tableView.tableFooterView = footer
    }
    
    private func displayImagePickerController() {
        let imagePicerController = UIImagePickerController()
        imagePicerController.delegate = self
        imagePicerController.sourceType = .photoLibrary
        present(imagePicerController, animated: true, completion: nil)
    }

    private func presentWelcomeController() {
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
    }

    private func presentCategoriesViewController() {
        let viewController = CategoriesViewController()
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func presentStockCompaniesViewController() {
        let viewController = StockCompaniesViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    private func updateControllerWithViewModel() {
        viewModel.indexPath.bind { [weak self] result in
            if let res = result {
                self?.tableView.reloadSections([res.section], with: .none)
            }
        }

        viewModel.updateWithUser = { [weak self] user in
            self?.header.nameTextField.text = "\(user.name)"
            self?.header.countryImageView.image = UIImage(named: user.country)
        }

        viewModel.result.bind { [weak self] result in
            switch result {
            case .presentCategoriesViewController:
                self?.presentCategoriesViewController()
            case .presentStockCompaniesViewController:
                self?.presentStockCompaniesViewController()
            case .presentWelcomeController:
                self?.presentWelcomeController()
            case .presentDeleteAlert:
                self?.presentDeleteAlert()
            default:
                break
            }
        }

        header.nameTextField.text = "\(viewModel.user.name)"
        header.userImageView.image = viewModel.image
        header.countryImageView.image = UIImage(named: viewModel.user.country)
    }

    func presentDeleteAlert() {
        let alertController = UIAlertController(title: "Warning!", message: "Do you want to delete your account?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.viewModel.deleteUser()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods
// MARK: -
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
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
                cell.countryLabel.text = viewModel.sections[indexPath.section].options[indexPath.row - 1]
                cell.countryImageView.image = UIImage(named: viewModel.sections[indexPath.section].countriesImages[indexPath.row - 1])
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
        return DefaultParameters.buttonHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}

// MARK: - UIImagePickerControllerDelegate methods
// MARK: -
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            header.userImageView.image = image
            viewModel.saveUserImage(image: image)
            tableView.reloadData()
        } else {
            fatalError("Can't find image")
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        if let text = textField.text {
            NotificationCenter.default.post(name: NSNotification.Name("profileName"), object: text)
        }
        return true
    }
}
