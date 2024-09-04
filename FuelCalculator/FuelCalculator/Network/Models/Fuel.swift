//
//  Fuel.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 6.05.24.
//

import Foundation

final class Fuel: Codable {
    let name: String?
    let amount: String?
    var fuelCode: String?
    var fuelName_ENG: String?
    var fuelName_BEL: String?
    var isSelected: Bool
    
    var writeOfCount: Double?
    
    init(name: String?, amount: String?, fuelCode: String? = nil, fuelName_ENG: String? = nil, fuelName_BEL: String? = nil, isSelected: Bool = false) {
        self.name = name
        self.amount = amount
        self.fuelCode = fuelCode
        self.fuelName_ENG = fuelName_ENG
        self.fuelName_BEL = fuelName_BEL
        self.isSelected = isSelected
    }
    
    var convertedAmount: Double? {
        guard let amount = amount else { return nil }
        return Double(amount)
    }
    
    var localisedName: String {
        if #available(iOS 16, *) {
            return setFuelName(language: Locale.current.language.languageCode?.identifier ?? "")
        } else {
            return setFuelName(language: Locale.current.identifier)
        }
    }
    
    func setFuelName(language: String) -> String {
        var tempFuelName: String?
        switch language {
        case "be":
            tempFuelName = fuelName_BEL
        case "en":
            tempFuelName = fuelName_ENG
        case "ru":
            tempFuelName = name
        default:
            tempFuelName = fuelName_ENG
        }
        return tempFuelName ?? ""
    }
    
    func getWriteOfAmount(currency: CurrencyData) -> Double? {
        guard let rate = currency.currencyOfficialRate,
              let scale = currency.currencyScale else { return nil }
        return rate / Double(scale)
    }
}
