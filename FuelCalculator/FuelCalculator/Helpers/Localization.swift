//
//  Localization.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 3.05.24.
//

import Foundation

public func LS(_ key: String) -> String {
    return Bundle.main.localizedString(forKey: key, value: key, table: nil)
}
