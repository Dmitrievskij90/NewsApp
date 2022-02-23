//
//  Helpers.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 09.09.2021.
//

import Foundation

class Helpers {
    static let shared = Helpers()
    
    lazy var dateFormatter = DateFormatter()
    
    func convertDate(date: String, oldDateformat: String = "yyyy-MM-dd'T'HH:mm:ssZ", newDateFormat: String = "dd MMMM yyyy, HH:mm") -> String {
        dateFormatter.dateFormat = oldDateformat
        
        guard let convertedDate = dateFormatter.date(from: date) else {
            return ""
        }
        
        dateFormatter.dateFormat = newDateFormat
        
        return dateFormatter.string(from: convertedDate)
    }
    
    func getCurrentDate() -> String {
        dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
        let dataString = dateFormatter.string(from: Date())
        return dataString
    }
}
