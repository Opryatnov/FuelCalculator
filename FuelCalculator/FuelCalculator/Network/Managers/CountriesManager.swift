//
//  CountriesManager.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 29.04.24.
//

import UIKit

final class CountriesManager {
    
    static var countries: Countries?
    
    static func fetchAllCountries(completion: @escaping (Countries?) -> Void) {
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jList = try JSONDecoder().decode([CountryModel].self, from: data)
                let countries = Countries(countries: jList)
                DispatchQueue.main.async {
                    completion(countries)
                    self.countries = countries
                }
                
            } catch let error {
                showError(message: error.localizedDescription)
                
            }
        } else {
            showError(message: "Invalid filename/path.")
        }
    }
    
    static func showError(message: String?) {
        let closeAction = [
            UIAlertAction(title: LS("ALERT.CLOSE.BUTTON"), style: .cancel)
        ]
        Navigation.currentController?.showAlert(message: message, buttons: closeAction, viewController: Navigation.currentController)
    }
}
