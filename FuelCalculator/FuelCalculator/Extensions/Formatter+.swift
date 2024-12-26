//
//  Formatter+.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 25.07.24.
//

import Foundation

extension Formatter {
    static func withFractionDigits(_ fractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter
    }

    static let withSeparator: NumberFormatter = withFractionDigits(3)

    static let integer: NumberFormatter = withFractionDigits(0)
}
