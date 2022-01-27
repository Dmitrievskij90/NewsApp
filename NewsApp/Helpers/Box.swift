//
//  Box.swift
//  NewsApp
//
//  Created by Konstantin Dmitrievskiy on 12.12.2021.
//

import Foundation

final class Box<T> {
    typealias Listener = (T) -> Void

    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
