//
//  Validator.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 25.07.24.
//

import Foundation

final class Validator {
    class func isValid(_ value: String, type: ValidationFieldType) -> Bool {
        let regex = try? NSRegularExpression(pattern: type.businessRule, options: [])
        return regex?.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) != nil
    }
}

enum ValidationFieldType {
    case balanceInputTwoNumbersCurrencyAfterPoint
    
    var businessRule: String {
        switch self {
        case .balanceInputTwoNumbersCurrencyAfterPoint:
            return "(^[0-9]{0,6}$|(^[0-9]{0,6}([.][0-9]{0,2})?$))"
        }
    }
}
