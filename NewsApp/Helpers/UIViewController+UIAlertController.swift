//
//  UIViewController+UIAlertController.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 13.09.2021.
//

import UIKit

extension UIViewController {
    func presentOneButtonAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
