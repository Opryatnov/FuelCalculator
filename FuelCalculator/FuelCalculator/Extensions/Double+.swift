//
//  Double+.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 25.07.24.
//

import Foundation

extension Double {
    func round(to places: Int = 3) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
