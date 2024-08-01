//
//  CurrenciesManager.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 3.05.24.
//

import UIKit

final class CurrenciesManager {
    
    static let shared = CurrenciesManager()
    private init() {}
    
    var allCurrencyData: [FullCurrencyData]? = []
    
    func fetchCurrencies() {
        if let path = Bundle.main.path(forResource: "allCurrenciesWithLanguages", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jList = try JSONDecoder().decode([FullCurrencyData].self, from: data)
                DispatchQueue.main.async {
                    self.allCurrencyData = jList
                }
                
            } catch let error {
                allCurrencyData = nil
                showError(message: error.localizedDescription)
            }
        } else {
            allCurrencyData = nil
            showError(message: "Invalid filename/path.")
        }
    }
    
    private func showError(message: String?) {
        let closeAction = [
            UIAlertAction(title: LS("ALERT.CLOSE.BUTTON"), style: .cancel)
        ]
        Navigation.currentController?.showAlert(message: message, buttons: closeAction, viewController: Navigation.currentController)
    }
}
