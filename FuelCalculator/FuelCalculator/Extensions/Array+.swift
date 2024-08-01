//
//  Array+.swift
//  CurrencyConverter
//
//  Created by Dmitriy Opryatnov on 21.06.24.
//

import Foundation

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
