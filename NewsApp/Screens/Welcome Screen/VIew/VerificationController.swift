//
//  VerifyController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 07.11.2021.
//

import UIKit

class VerificationController: UIViewController {
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private let alertView = VerificationAlertView()
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let viewModel = VerificationControllerViewModel()
    
    private let letsGoButton: UIButton = {
        let button = BaseButton(type: .system)
        button.setTitle("Let's go", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.init(hex: 0x4EFDD), for: .normal)
        button.backgroundColor = .init(hex: 0x494d4e)
        button.addTarget(self, action: #selector(letsGoButonPressed), for: .touchUpInside)
        return button
    }()
    
    private let setupProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "Set up profile"
        label.font = .boldSystemFont(ofSize: 35)
        label.textAlignment = .center
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let userImageView: CircularImageView = {
        let imageView = CircularImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.init(hex: 0x494d4e).cgColor
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "imagePlaceholder")
        return imageView
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.constrainWidth(constant: 50)
        button.constrainHeight(constant: 50)
        button.tintColor = .init(hex: 0x494d4e)
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "User name"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField(placeholder: "Reader")
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        return textField
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Country:"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let countryRussiaButton = UIButton()
    private let countryUSAButton = UIButton()
    private let countryFranceButton = UIButton()
    private let countryGermanyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self

        let tapGestureregognizer = UITapGestureRecognizer(target: self, action: #selector(userImageViewTapped))
        userImageView.addGestureRecognizer(tapGestureregognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reloadUser()
        updateControllerWithVIewModel()
    }
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = .label
        
        setupCountryButtons(with: countryRussiaButton, imageName: "ru", tag: 1)
        setupCountryButtons(with: countryUSAButton, imageName: "us", tag: 2)
        setupCountryButtons(with: countryFranceButton, imageName: "fr", tag: 3)
        setupCountryButtons(with: countryGermanyButton, imageName: "de", tag: 4)
        
        view.addSubview(setupProfileLabel)
        setupProfileLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 50, bottom: 0, right: 50), size: .init(width: 0, height: view.frame.height / 11.5))
        
        view.addSubview(userImageView)
        userImageView.anchor(top: setupProfileLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.height / 7, height: view.frame.height / 7))
        userImageView.centerXInSuperview()
        
        view.addSubview(plusButton)
        plusButton.anchor(top: nil, leading: nil, bottom: userImageView.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        plusButton.centerXInSuperview(constantX: 50)
        
        view.addSubview(nameTextField)
        nameTextField.anchor(top: userImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: DefaultParameters.buttonWidth, height: DefaultParameters.buttonHeight))
        nameTextField.centerXInSuperview()
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: nil, leading: nil, bottom: nameTextField.topAnchor, trailing: nil, size: .init(width: DefaultParameters.buttonWidth, height: 30))
        nameLabel.centerXInSuperview()
        
        view.addSubview(letsGoButton)
        letsGoButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 50, right: 0), size: .init(width: DefaultParameters.buttonWidth, height: DefaultParameters.buttonHeight))
        letsGoButton.centerXInSuperview()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        setupCountryStackView()
        setupVerificationAlertView()
    }
    
    private func setupCountryButtons(with button: UIButton, imageName: String, tag: Int) {
        button.tag = tag
        button.setImage(UIImage(named: imageName), for: .normal)
        button.contentMode = .scaleAspectFill
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = .init(width: 0, height: 10)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
    }
    
    private func setupCountryStackView() {
        let stackVIew = UIStackView(arrangedSubviews: [countryRussiaButton, countryUSAButton, countryGermanyButton, countryFranceButton])
        stackVIew.spacing = 5
        stackVIew.distribution = .fillEqually
        
        view.addSubview(stackVIew)
        stackVIew.anchor(top: nameTextField.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: DefaultParameters.buttonWidth - 40, height: DefaultParameters.buttonHeight))
        stackVIew.centerXInSuperview()
        
        view.addSubview(countryLabel)
        countryLabel.anchor(top: nil, leading: nil, bottom: stackVIew.topAnchor, trailing: nil, size: .init(width: DefaultParameters.buttonWidth, height: 30))
        countryLabel.centerXInSuperview()
    }
    
    private func setupVerificationAlertView() {
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = alertView.topAnchor.constraint(equalTo: view.bottomAnchor)
        topConstraint?.isActive = true
        bottomConstraint = alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        bottomConstraint?.isActive = false
        alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        alertView.tapHandler = { [weak self] in
            self?.viewModel.reloadUser()
            self?.hideAlertView()
        }
    }

    private func hideAlertView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.topConstraint?.isActive = true
            self.bottomConstraint?.isActive = false
            self.blurVisualEffectView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func showAlertView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.topConstraint?.isActive = false
            self.bottomConstraint?.isActive = true
            self.blurVisualEffectView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func countryButtonTapped(button: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("country"), object: button.tag)
        switch button.tag {
        case 1:
            animateCountryButton(button: button)
            resetButtons(buttons: [countryUSAButton, countryGermanyButton, countryFranceButton])
        case 2:
            animateCountryButton(button: button)
            resetButtons(buttons: [countryRussiaButton, countryGermanyButton, countryFranceButton])
        case 3:
            animateCountryButton(button: button)
            resetButtons(buttons: [countryUSAButton, countryGermanyButton, countryRussiaButton])
        case 4:
            animateCountryButton(button: button)
            resetButtons(buttons: [countryUSAButton, countryRussiaButton, countryFranceButton])
        default:
            animateCountryButton(button: button)
            resetButtons(buttons: [countryRussiaButton, countryGermanyButton, countryFranceButton])
        }
    }
    
    private func animateCountryButton(button: UIButton) {
        if button.transform == .identity {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                button.transform = .init(scaleX: 0.8, y: 0.8)
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                button.transform = .identity
            }
        }
    }
    
    private func resetButtons(buttons: [UIButton]) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            for button in buttons {
                button.transform = .identity
            }
        }
    }
    
    @objc private func cancelButonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func letsGoButonPressed() {
        viewModel.letsGoButonPressed()
    }

    private func updateControllerWithVIewModel() {
        viewModel.result.bind { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .presentTabBarController:
                self.presentBaseTabBarController()
            case .showAlertView:
                self.showAlertView()
            default:
                break
            }
        }
    }
    
    @objc private func userImageViewTapped() {
        displayImagePickerController()
    }
    
    @objc private func plusButtonPressed() {
        displayImagePickerController()
    }

    private func displayImagePickerController() {
        let imagePicerController = UIImagePickerController()
        imagePicerController.delegate = self
        imagePicerController.sourceType = .photoLibrary
        present(imagePicerController, animated: true, completion: nil)
    }

    private func presentBaseTabBarController() {
        let dV = BaseTabBarController()
        dV.modalPresentationStyle = .fullScreen
        present(dV, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate methods
//MARK: -
extension VerificationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            userImageView.image = image
            viewModel.saveUserImage(image: image)
        } else {
            fatalError("Can't find image")
        }
        dismiss(animated: true, completion: nil)
    }
}

extension VerificationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            NotificationCenter.default.post(name: NSNotification.Name("name"), object: text)
        }
    }
}

