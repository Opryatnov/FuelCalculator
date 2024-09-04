//
//  Decimal+.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 25.07.24.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        Double("\(self)") ?? 0
    }
    
    func formattedWithSeparator(_ minimumFractionDigits: Int = 0) -> String {
        let formatter = Formatter.withSeparator
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = max(3, minimumFractionDigits)
        return formatter.string(for: self) ?? ""
    }
    
    func formattedWithSeparator(maximumFractionDigits: Int) -> String {
        let formatter = Formatter.withSeparator
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(for: self) ?? ""
    }
}
