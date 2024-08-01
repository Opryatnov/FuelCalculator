//
//  CountryModel.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 29.04.24.
//

import UIKit

struct CountryModel: Decodable {
    let code: String?
    let name: String?
    let country: String?
    let countryCode: String?
    let flag: String?
    
    var decodedImage: UIImage? {
        guard let flag else { return nil }
        let tempFlag = flag
            .replacingOccurrences(of: "data:image/png;base64,", with: "")
        if let imageData = Data(base64Encoded: tempFlag) {
            return UIImage(data: imageData)
        } else {
            return nil
        }
    }
}

struct Countries {
    let countries: [CountryModel]?
    
    init(countries: [CountryModel]?) {
        self.countries = countries
    }
}
