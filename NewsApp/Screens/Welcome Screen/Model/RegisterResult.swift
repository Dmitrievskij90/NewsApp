//
//  RegisterResult.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 26.12.2021.
//

import Foundation

enum RegisterResult {
    case emptyField
    case passwordsNotmatch
    case badEmailFormat
    case userAlredyExists
    case registrationFailed
    case presentVerificationController
    case shortPassword
}
