//
//  String+.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 25.07.24.
//

import Foundation

extension String {
    func toAmountFormat() -> String {
        Self.grouping(with: .space, decimalNumber: NSDecimalNumber(string: self.replacingCommaWithDot.withoutSpaces))
    }
    
    static func grouping(with separator: SeparatorType, decimalNumber: NSDecimalNumber) -> String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 3
        
        return numberFormatter.string(from: decimalNumber) ?? ""
    }
    
    enum SeparatorType: String {
        case space = " "
        case withoutSpace = ""
    }
    
    var replacingCommaWithDot: String {
        replacingOccurrences(of: ",", with: ".")
    }
    
    var withoutSpaces: String {
        String(self.filter { $0 != " " })
    }
    
    func toDouble() -> Double? {
        let formatter = Formatter.withSeparator
        if let number = formatter.number(from: self) {
            return Double(truncating: number)
        } else {
            return nil
        }
    }
}
