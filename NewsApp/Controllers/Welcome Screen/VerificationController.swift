//
//  VerifyController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 07.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class VerificationController: UIViewController {
    private let fileManager = FileManager.default
    private let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin)
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private let alertView = VerificationAlertView()
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let letsGoButton: UIButton = {
        let button = BaseButton(type: .system)
        button.setTitle("Let's go", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(hex: 0x16697A)
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
        imageView.image = UIImage(named: "avatar_image")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.tintColor = .init(hex: 0x494d4e)
        imageView.constrainWidth(constant: 120)
        imageView.constrainHeight(constant: 120)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().currentUser?.reload()

        let tapGestureregognizer = UITapGestureRecognizer(target: self, action: #selector(userImageViewTapped))
        userImageView.addGestureRecognizer(tapGestureregognizer)
    }

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = .label

        view.addSubview(setupProfileLabel)
        setupProfileLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 50, bottom: 0, right: 50), size: .init(width: 0, height: 80))

        view.addSubview(userImageView)
        userImageView.anchor(top: setupProfileLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        userImageView.centerXInSuperview()

        view.addSubview(plusButton)
        plusButton.anchor(top: nil, leading: nil, bottom: userImageView.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        plusButton.centerXInSuperview(constantX: 50)

        view.addSubview(letsGoButton)
        letsGoButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 50, right: 50), size: .init(width: 0, height: 50))
        letsGoButton.centerXInSuperview()

        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0

        setupVerificationAlertView()
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

        alertView.tapHandler = {
            Auth.auth().currentUser?.reload()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
                self.topConstraint?.isActive = true
                self.bottomConstraint?.isActive = false
                self.blurVisualEffectView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    func showAlertView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.topConstraint?.isActive = false
            self.bottomConstraint?.isActive = true
            self.blurVisualEffectView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    @objc func cancelButonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc func letsGoButonPressed() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        user.reload { _ in
            switch user.isEmailVerified {
            case true:
                self.presentBaseTabBarController()
            case false:
                self.showAlertView()
            }
        }
    }

    @objc func userImageViewTapped() {
        displayImagePickerController()
    }

    @objc func plusButtonPressed() {
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
        guard let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(AppSettingsManager.shared.userLogin) else {
            return
        }

        if let image = info[.originalImage] as? UIImage {
//            try? FileManager.default.createDirectory(at: documentsPath, withIntermediateDirectories: false, attributes: nil)
            userImageView.image = image
            if fileManager.fileExists(atPath: documentsPath.path) == false {
                do {
                    try fileManager.createDirectory(atPath: documentsPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    fatalError("Can't save image to directory")
                }
            }
            let data = image.jpegData(compressionQuality: 0.5)
            let imageName = "userImage.png"
            fileManager.createFile(atPath: "\(documentsPath.path)/\(imageName)", contents: data, attributes: nil)

        } else {
            fatalError("Can't find image")
        }
        dismiss(animated: true, completion: nil)
    }
}
